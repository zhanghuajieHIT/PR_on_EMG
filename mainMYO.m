%% main function for data of MYO

clc;
clear;
trainRawEmg=load('C:\Users\zhj\Desktop\myodata\rawEmg\rawData1ok.mat');
testRawEmg=load('C:\Users\zhj\Desktop\myodata\rawEmg\rawData2ok.mat');

trainRawData=trainRawEmg.rawData.data(:,1:8,:);
trainLabel=trainRawEmg.rawData.label';
testRawData=testRawEmg.rawData.data(:,1:8,:);
testLabel=testRawEmg.rawData.label';

%% feature extrated  
trainLen=size(trainRawData,3);
trainFeature=zeros(trainLen,8);
testLen=size(testRawData,3);
testFeature=zeros(testLen,8);
fun='feature_MAV';%可以修改提取特征的函数
for i=1:trainLen
    trainFeature(i,:)=feval(fun,trainRawData(:,:,i));
end
for i=1:testLen
    testFeature(i,:)=feval(fun,testRawData(:,:,i));
end
%归一化
trainFeature=mapminmax(trainFeature',0,5)';
testFeature=mapminmax(testFeature',0,5)';

%% classify
model = libsvmtrain(trainLabel, trainFeature, '-c 3.2 -g 0.01');
[predict_label, acc,~] = libsvmpredict(testLabel, testFeature, model);

