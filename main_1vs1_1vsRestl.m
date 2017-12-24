%% SVM����Ľ�
% 1vs1��1vs����,Ч������
clc;
clear;

%% load data
floderPath='H:\��������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
FUN='feature_DFT_MAV2';%�����޸���ȡ�����ĺ���
dataTrainName='a1a2';
dataTestName='b1b2';
load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat']);
trainData=featSaved(:,1:end-1);
trainData=real(trainData);
trainData=mapminmax(trainData',0,5)';%��һ��
trainLabel=featSaved(:,end);
load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTestName,'.mat']);
testData=featSaved(:,1:end-1);
testData=real(testData);
testData=mapminmax(testData',0,5)';%��һ��
testLabel=featSaved(:,end);

%% ��������
index=unique(trainLabel);
indexNum=length(index);% indexNum=14������������
trainDataTemp=[];
trainLabelTemp=[];
for i=1:indexNum
    [row,~]=find(trainLabel==index(i));
    trainDataTemp=cat(1,trainDataTemp,trainData(row,:));
    trainLabelTemp=cat(1,trainLabelTemp,trainLabel(row));
end
trainData=trainDataTemp;
trainLabel=trainLabelTemp;

MODEL=libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');

%% ѵ��ģ��
featNumOneClass=length(trainLabel)/indexNum;%ÿ�ֶ�����������
allModel=[];%���ڱ������е�svmѵ��model
for i=1:indexNum
    %% ���ݷ���
   class1=trainData(1+(i-1)*featNumOneClass:i*featNumOneClass,:);%��i������
   label1=trainLabel(1+(i-1)*featNumOneClass:i*featNumOneClass);
   class2_temp=trainData;
   label2_temp=trainLabel;
   class2_temp(1+(i-1)*featNumOneClass:i*featNumOneClass,:)=[];
   label2_temp(1+(i-1)*featNumOneClass:i*featNumOneClass)=[];
   class2=class2_temp;
   randNum=randperm(size(class2,1));
   class2=class2(randNum(1:length(label1)),:);
   label2=(indexNum+1)*ones(size(class2,1),1);%����all�������趨�µ�label
   %% ѵ��ģ��
   trainDataNew=[class1;class2];
   trainLabelNew=[label1;label2];
   model = libsvmtrain(trainLabelNew, trainDataNew, '-c 32 -g 0.01');
   allModel=cat(2,allModel,model);
end

%% ����
modelNum=length(allModel);
predict_label=zeros(length(testLabel),1);
predictResult=[];
featNum=size(testData,1);%�������ݵ�������
count=0;
for i=1:featNum
    testDataNew=testData(i,:);
    testLabelNew=testLabel(i,:);
    voteLabel=zeros(indexNum,1);
    predict_label_temp=[];
    for j=1:modelNum
        [predictLabel, ~,~] = libsvmpredict(testLabelNew, testDataNew, allModel(j));
        if j==predictLabel
            predict_label_temp=cat(1,predict_label_temp,predictLabel);
        end
    end
    NUM=length(predict_label_temp);
    if NUM==1%�п���Ϊ0���߳���1
        predict_label(i,1)=predict_label_temp;
    elseif NUM==0
%         error('����������');
        [predict_label(i,1),~,~]=libsvmpredict(testLabelNew,testDataNew,Model);
        count=count+1;
    elseif NUM>1
        train_data=[];
        train_label=[];
        for ii=1:NUM
            train_data=cat(1,train_data,trainData(1+(predict_label_temp(ii)-1)*featNumOneClass:predict_label_temp(ii)*featNumOneClass,:));
            train_label=cat(1,train_label,trainLabel(1+(predict_label_temp(ii)-1)*featNumOneClass:predict_label_temp(ii)*featNumOneClass,:));
        end
        Model=libsvmtrain(train_label,train_data,'-c 32 -g 0.01');
        [predict_label(i,1),~,~]=libsvmpredict(testLabelNew,testDataNew,Model);
    end
end

%% ������ȷ��
Acc=length(find(predict_label==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(Acc*100),'%%\n']);

