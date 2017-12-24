%% SVM分类改进
% 1vs1和1vs多结合,效果更差
clc;
clear;

%% load data
floderPath='H:\特征保存\zhj20161219\无归一化预处理后，overlap为100,len为300';
FUN='feature_DFT_MAV2';%可以修改提取特征的函数
dataTrainName='a1a2';
dataTestName='b1b2';
load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat']);
trainData=featSaved(:,1:end-1);
trainData=real(trainData);
trainData=mapminmax(trainData',0,5)';%归一化
trainLabel=featSaved(:,end);
load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat']);
testData=featSaved(:,1:end-1);
testData=real(testData);
testData=mapminmax(testData',0,5)';%归一化
testLabel=featSaved(:,end);

%% 数据排序
index=unique(trainLabel);
indexNum=length(index);% indexNum=14，动作种类数
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

%% 训练模型
featNumOneClass=length(trainLabel)/indexNum;%每种动作的样本数
allModel=[];%用于保存所有的svm训练model
for i=1:indexNum
    %% 数据分组
   class1=trainData(1+(i-1)*featNumOneClass:i*featNumOneClass,:);%第i类数据
   label1=trainLabel(1+(i-1)*featNumOneClass:i*featNumOneClass);
   class2_temp=trainData;
   label2_temp=trainLabel;
   class2_temp(1+(i-1)*featNumOneClass:i*featNumOneClass,:)=[];
   label2_temp(1+(i-1)*featNumOneClass:i*featNumOneClass)=[];
   class2=class2_temp;
   randNum=randperm(size(class2,1));
   class2=class2(randNum(1:length(label1)),:);
   label2=(indexNum+1)*ones(size(class2,1),1);%给“all”数据设定新的label
   %% 训练模型
   trainDataNew=[class1;class2];
   trainLabelNew=[label1;label2];
   model = libsvmtrain(trainLabelNew, trainDataNew, '-c 32 -g 0.01');
   allModel=cat(2,allModel,model);
end

%% 测试
modelNum=length(allModel);
predict_label=zeros(length(testLabel),1);
predictResult=[];
featNum=size(testData,1);%测试数据的样本数
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
    if NUM==1%有可能为0或者超过1
        predict_label(i,1)=predict_label_temp;
    elseif NUM==0
%         error('出现了问题');
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

%% 计算正确率
Acc=length(find(predict_label==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(Acc*100),'%%\n']);

