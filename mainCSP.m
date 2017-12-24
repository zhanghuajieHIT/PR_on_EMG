%% main function with CSP

clc;
clear; 

%% load data
train1=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\c1.mat');
train2=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\c2.mat');
train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
test1=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\e1.mat');
test2=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\e2.mat');
test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
fun='feature_MAV';%�����޸���ȡ�����ĺ���
trainLen=size(train.DataStructure.rawEMG,3);
trainData=zeros(trainLen,8);    %ע������������Ϊ8����ͬ���������ܲ�һ��
testLen=size(test.DataStructure.rawEMG,3);
testData=zeros(testLen,8);
for i=1:trainLen
    trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');
end
trainLabel=train.DataStructure.labelID;
trainData=mapminmax(trainData',0,5)';%��һ��
for i=1:testLen   
    testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');
end
testLabel=test.DataStructure.labelID;
testData=mapminmax(testData',0,5)';%��һ��

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

%% CSP process
index=unique(trainLabel);
indexNum=length(index);
featNum=length(trainLabel)/indexNum;
% svm��ѵ��ģ��model
allModel=[];
allWF={};
for i=1:indexNum-1
    class1=trainData(1+(i-1)*featNum:featNum+(i-1)*featNum,:);
    label1=trainLabel(1+(i-1)*featNum:featNum+(i-1)*featNum,:);
    for j=i+1:indexNum
        class2=trainData(1+(j-1)*featNum:j*featNum,:);
        label2=trainLabel(1+(j-1)*featNum:j*featNum,:);
        WF=CSP_opt(class1,class2);
        allWF=cat(1,allWF,WF);
        trainDataNew=[class1*WF;class2*WF];
        trainLabelNew=[label1;label2];
        model = libsvmtrain(trainLabelNew, trainDataNew, '-c 32 -g 0.01');
        allModel=cat(2,allModel,model);
    end   
end
% ���ԣ�ͶƱ���
modelNum=length(allModel);
predictResult=[];
featNum=size(testData,1);
count=0;
for i=1:featNum
    testDataNew=testData(i,:);
    testLabelNew=testLabel(i,:);
    voteLabel=zeros(14,1);
    for j=1:modelNum
        [predictLabel, ~,~] = libsvmpredict(testLabelNew, testDataNew*allWF{j,1}, allModel(j));
        voteLabel(predictLabel,1)=voteLabel(predictLabel,1)+1;
    end
    [maxLabel,loc]=max(voteLabel);%ͶƱ�õ��Ľ��
     % ����ͶƱ�����ͬ�����
    [maxLabelNum,~]=find(voteLabel==maxLabel);
    if (length(maxLabelNum))>1
        count=count+1;
    end
    predictResult=cat(1,predictResult,loc);
end
% ������ȷ��
Acc=length(find(predictResult==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(Acc*100),'%%\n']);

