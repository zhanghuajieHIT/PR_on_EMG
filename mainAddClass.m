%% 难分数据再分方法

%% load data
clc;
clear; 
% load('E:\实验\杨老师数据\EMG data.mat');
% train.DataStructure.rawEMG=DataStructure{1, 1}.rawEMG;
% train.DataStructure.labelID=DataStructure{1, 1}.labelID;
% test.DataStructure.rawEMG=DataStructure{1, 2}.rawEMG;
% test.DataStructure.labelID=DataStructure{1, 2}.labelID;

train1=load('C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300\e1.mat');
train2=load('C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300\e2.mat');
% train3=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\无归一化预处理后，overlap为100,len为300\a3.mat');
% train4=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\无归一化预处理后，overlap为100,len为300\a4.mat');
train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
% train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
% train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
% train.DataStructure.rawEMG=train1.DataStructure.rawEMG;
% train.DataStructure.labelID=train1.DataStructure.labelID;
test1=load('C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300\a1.mat');
test2=load('C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300\a2.mat');
test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
fun='feature_WAMP';%可以修改提取特征的函数
trainLen=size(train.DataStructure.rawEMG,3);
trainData=zeros(trainLen,8);    %注意特征的列数为8，不同的特征可能不一样
testLen=size(test.DataStructure.rawEMG,3);
testData=zeros(testLen,8);
% trainData(1,1:8)=feature_RMS(train.DataStructure.rawEMG(:,:,1)');%针对DRMS2特征
for i=1:trainLen
%     trainTemp=remSamp(train.DataStructure.rawEMG(:,:,i)');
%     trainData(i,:)=feval(fun,trainTemp);
    
    trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');

%     trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)',trainData(i-1,:));%针对DRMS2特征
%     trainData(i,:)=feature_RMS(train.DataStructure{1, 1}.rawEMG(:,:,i)');
%     trainData(i,:)=feval(f,train.DataStructure.rawEMG(:,:,i)');
end

trainLabel=train.DataStructure.labelID;
trainData=mapminmax(trainData',0,5)';%归一化

% testData(1,1:8)=feature_RMS(test.DataStructure.rawEMG(:,:,1)');%针对DRMS2特征
for i=1:testLen
%     testTemp=remSamp(test.DataStructure.rawEMG(:,:,i)');
%     testData(i,:)=feval(fun,testTemp);   
    
    testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');

%     testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)',testData(i-1,:));%针对DRMS2特征
%     testData(i,:)=feature_RMS(test.DataStructure{1, 3}.rawEMG(:,:,i)');
%     testData(i,:)=feval(f,test.DataStructure.rawEMG(:,:,i)');
end

testLabel=test.DataStructure.labelID;
testData=mapminmax(testData',0,5)';%归一化

%% 数据重新排序
indexTrain=unique(trainLabel);
indexTrainNum=length(indexTrain);% indexNum=14，动作种类数
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

%% svm分类
%% 原始方法
model1 = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
[predict_label1, ~,~] = libsvmpredict(testLabel, testData, model1);
AccOld=length(find(predict_label1==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(AccOld*100),'%%\n']);

%% 增加类别方法
%原始方法中每种动作模式的识别率，识别效果较差的用增加类方法
% 标签修正
% 判断识别效果较差的类
accOneClass=[];
featNumOneClass=length(trainLabel)/indexTrainNum;%每种动作的样本数,为188
for i=1:indexTestNum
    accOneClassTemp=length(find(predict_label1(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass)==i))/length(find(testLabel==i));
    accOneClass=cat(1,accOneClass,accOneClassTemp);%计算每一类的识别成功率
end
[~,accSort]=sort(accOneClass);
% 选择分类效果最差的addNum类使用新方法
trainLabelNew=trainLabel;
addNum=1;%有多少个原始类需要增加类
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
    predictLabel(B)=accSort(j);%新增加的类还原为原始的类别
    j=j+1;
end
AccNew=length(find(predictLabel==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(AccNew*100),'%%\n']);


