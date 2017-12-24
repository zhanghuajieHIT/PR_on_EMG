%% �ѷ������ٷַ���

%% load data
clc;
clear; 
% load('E:\ʵ��\����ʦ����\EMG data.mat');
% train.DataStructure.rawEMG=DataStructure{1, 1}.rawEMG;
% train.DataStructure.labelID=DataStructure{1, 1}.labelID;
% test.DataStructure.rawEMG=DataStructure{1, 2}.rawEMG;
% test.DataStructure.labelID=DataStructure{1, 2}.labelID;

train1=load('C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\e1.mat');
train2=load('C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\e2.mat');
% train3=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\14�ֶ���ģʽ\zhj20161123\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a3.mat');
% train4=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\14�ֶ���ģʽ\zhj20161123\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a4.mat');
train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
% train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
% train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
% train.DataStructure.rawEMG=train1.DataStructure.rawEMG;
% train.DataStructure.labelID=train1.DataStructure.labelID;
test1=load('C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a1.mat');
test2=load('C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a2.mat');
test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
fun='feature_WAMP';%�����޸���ȡ�����ĺ���
trainLen=size(train.DataStructure.rawEMG,3);
trainData=zeros(trainLen,8);    %ע������������Ϊ8����ͬ���������ܲ�һ��
testLen=size(test.DataStructure.rawEMG,3);
testData=zeros(testLen,8);
% trainData(1,1:8)=feature_RMS(train.DataStructure.rawEMG(:,:,1)');%���DRMS2����
for i=1:trainLen
%     trainTemp=remSamp(train.DataStructure.rawEMG(:,:,i)');
%     trainData(i,:)=feval(fun,trainTemp);
    
    trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');

%     trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)',trainData(i-1,:));%���DRMS2����
%     trainData(i,:)=feature_RMS(train.DataStructure{1, 1}.rawEMG(:,:,i)');
%     trainData(i,:)=feval(f,train.DataStructure.rawEMG(:,:,i)');
end

trainLabel=train.DataStructure.labelID;
trainData=mapminmax(trainData',0,5)';%��һ��

% testData(1,1:8)=feature_RMS(test.DataStructure.rawEMG(:,:,1)');%���DRMS2����
for i=1:testLen
%     testTemp=remSamp(test.DataStructure.rawEMG(:,:,i)');
%     testData(i,:)=feval(fun,testTemp);   
    
    testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');

%     testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)',testData(i-1,:));%���DRMS2����
%     testData(i,:)=feature_RMS(test.DataStructure{1, 3}.rawEMG(:,:,i)');
%     testData(i,:)=feval(f,test.DataStructure.rawEMG(:,:,i)');
end

testLabel=test.DataStructure.labelID;
testData=mapminmax(testData',0,5)';%��һ��

%% ������������
indexTrain=unique(trainLabel);
indexTrainNum=length(indexTrain);% indexNum=14������������
trainDataTemp=[];
trainLabelTemp=[];
indexTest=unique(testLabel);
indexTestNum=length(indexTest);
testDataTemp=[];
testLabelTemp=[];
for i=1:indexTrainNum
    [rowTrain,~]=find(trainLabel==indexTrain(i));
    trainDataTemp=cat(1,trainDataTemp,trainData(rowTrain,:));
    trainLabelTemp=cat(1,trainLabelTemp,trainLabel(rowTrain));
end
trainData=trainDataTemp;
trainLabel=trainLabelTemp;
for i=1:indexTestNum
    [rowTest,~]=find(testLabel==indexTest(i));
    testDataTemp=cat(1,testDataTemp,testData(rowTest,:));
    testLabelTemp=cat(1,testLabelTemp,testLabel(rowTest));
end
testData=testDataTemp;
testLabel=testLabelTemp;

%% svm����
%% ԭʼ����
model1 = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
[predict_label1, ~,~] = libsvmpredict(testLabel, testData, model1);
AccOld=length(find(predict_label1==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(AccOld*100),'%%\n']);

%% ������𷽷�
%ԭʼ������ÿ�ֶ���ģʽ��ʶ���ʣ�ʶ��Ч���ϲ���������෽��
% ��ǩ����
% �ж�ʶ��Ч���ϲ����
accOneClass=[];
featNumOneClass=length(trainLabel)/indexTrainNum;%ÿ�ֶ�����������,Ϊ188
for i=1:indexTestNum
    accOneClassTemp=length(find(predict_label1(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass)==i))/length(find(testLabel==i));
    accOneClass=cat(1,accOneClass,accOneClassTemp);%����ÿһ���ʶ��ɹ���
end
[~,accSort]=sort(accOneClass);
% ѡ�����Ч������addNum��ʹ���·���
trainLabelNew=trainLabel;
addNum=1;%�ж��ٸ�ԭʼ����Ҫ������
for i=1:addNum
    index=accSort(i);
    trainLabelNew(1+(index-1)*featNumOneClass:0.5*featNumOneClass+(index-1)*featNumOneClass)=indexTrainNum+i;
end
model2 = libsvmtrain(trainLabelNew, trainData, '-c 32 -g 0.01');
[predict_label2, ~,~] = libsvmpredict(testLabel, testData, model2);
predictLabel=predict_label2;
j=1;
for i=(indexTrainNum+1):(indexTrainNum+addNum)
    A=find(trainLabelNew==i);
    B=find(predict_label2(A)==i);
    predictLabel(B)=accSort(j);%�����ӵ��໹ԭΪԭʼ�����
    j=j+1;
end
AccNew=length(find(predictLabel==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(AccNew*100),'%%\n']);


