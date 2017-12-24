%% Main function
clc;
clear; 
%% load data
FUN='feature_DFT_MAV1';%可以修改提取特征的函数
dataTrainName='e1e2e3e4';
dataTestName='d1d2d3d4';
file='E:\zhj\zhj20170322\特征保存';
load([file,'\',FUN,'-',dataTrainName,'.mat']);
trainData=real(featSaved(:,1:end-1));
trainData=mapminmax(trainData',0,5)';
% trainData=trainData(:,1:6);
% Temp=(sum(trainData'.^2))'.^0.5;
% for i=1:length(Temp)
%     trainData(i,:)=trainData(i,:)/Temp(i);
% end
trainLabel=real(featSaved(:,end));

load([file,'\',FUN,'-',dataTestName,'.mat']);
testData=real(featSaved(:,1:end-1));
testData=mapminmax(testData',0,5)';%归一化到0-1更好
% testData=testData(:,1:6);
% Temp=(sum(testData'.^2))'.^0.5;
% for i=1:length(Temp)
%     testData(i,:)=testData(i,:)/Temp(i);
% end
testLabel=real(featSaved(:,end));

%% 简单动作组
% [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
% [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
% trainData=mapminmax(trainData',0,5)';%归一化
% testData=mapminmax(testData',0,5)';%归一化
%% classify
kernelType='rbf';
result=[];
% for i=101:1:200
kernelPara=[0.005];
k_train=kernelFunc(trainData,kernelType,kernelPara);
k_test=kernelFunc(trainData,kernelType,kernelPara,testData);
Ktrain=[(1:size(trainData,1))',k_train];
model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
Ktest=[(1:size(testData,1))',k_test];
[predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);
accuracy=acc(1);
result=cat(1,result,accuracy);
% end

% kernelType=cell(1,3);
% kernelType{1,1}='rbf';
% kernelType{1,2}='expk';
% kernelType{1,3}='rq';
% kernelPara=[0.005,12.5,50];
% k_train=zeros(length(trainLabel),length(trainLabel));
% k_test=zeros(length(testLabel),length(testLabel));
% for i=1:length(kernelType)
%     trainDataTemp=trainData(:,(i-1)*16+1:16*i);
%     testDataTemp=testData(:,(i-1)*16+1:16*i);
%     [k_train_temp,kernelTemp]=multiKernelFunc(trainDataTemp,[],[],1,kernelType{1,i});
%     [k_test_temp,~]=multiKernelFunc(trainDataTemp,testDataTemp,kernelTemp,1,kernelType{1,i});  
% %     k_train_temp=kernelFunc(trainDataTemp,kernelType{1,i},kernelPara(i));
% %     k_test_temp=kernelFunc(trainDataTemp,kernelType{1,i},kernelPara(i),testDataTemp);
%     k_train=k_train+k_train_temp;
%     k_test=k_test+k_test_temp;
% end
% Ktrain=[(1:size(trainData,1))',k_train];
% model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
% Ktest=[(1:size(testData,1))',k_test];
% [predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);
% accuracy=acc(1);
