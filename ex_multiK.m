%% Main function
clc;
clear; 
%% load data
FUN='feature_DFT_MAV1';%可以修改提取特征的函数
dataTrainName='e1e2e3e4';
dataTestName='d1d2d3d4';
file='E:\zhj\zhj20170322\特征保存';
load([file,'\',FUN,'-',dataTrainName,'.mat']);
trainData=featSaved(:,1:end-1);
trainData=real(trainData);
trainData=mapminmax(trainData',0,5)';%归一化
trainLabel=featSaved(:,end);
load([file,'\',FUN,'-',dataTestName,'.mat']);
testData=featSaved(:,1:end-1);
testData=real(testData);
testData=mapminmax(testData',0,5)';%归一化
testLabel=featSaved(:,end);

%% 简单动作组
% [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
% [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
% trainData=mapminmax(trainData',0,5)';%归一化
% testData=mapminmax(testData',0,5)';%归一化

%% classify
% 3核效果比4核好
kernelType=cell(1,3);
kernelType{1,1}='rbf';
kernelType{1,2}='expk';
kernelType{1,3}='inmk';
% kernelType{1,4}='rq';
coef=[1,1,1];

[k_train,kernelTemp]=multiKernelFunc(trainData,[],[],coef,kernelType);
[k_test,~]=multiKernelFunc(trainData,testData,kernelTemp,coef,kernelType);    
Ktrain=[(1:size(trainData,1))',k_train];
model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
Ktest=[(1:size(testData,1))',k_test];
[predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);
accuracy=acc(1);
        
%% 保存所有的正确率
% Acc4=cat(1,Acc4,accuracy);