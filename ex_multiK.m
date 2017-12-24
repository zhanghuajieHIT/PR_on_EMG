%% Main function
clc;
clear; 
%% load data
FUN='feature_DFT_MAV1';%�����޸���ȡ�����ĺ���
dataTrainName='e1e2e3e4';
dataTestName='d1d2d3d4';
file='E:\zhj\zhj20170322\��������';
load([file,'\',FUN,'-',dataTrainName,'.mat']);
trainData=featSaved(:,1:end-1);
trainData=real(trainData);
trainData=mapminmax(trainData',0,5)';%��һ��
trainLabel=featSaved(:,end);
load([file,'\',FUN,'-',dataTestName,'.mat']);
testData=featSaved(:,1:end-1);
testData=real(testData);
testData=mapminmax(testData',0,5)';%��һ��
testLabel=featSaved(:,end);

%% �򵥶�����
% [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
% [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
% trainData=mapminmax(trainData',0,5)';%��һ��
% testData=mapminmax(testData',0,5)';%��һ��

%% classify
% 3��Ч����4�˺�
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
        
%% �������е���ȷ��
% Acc4=cat(1,Acc4,accuracy);