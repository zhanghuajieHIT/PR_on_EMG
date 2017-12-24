%% 自己写的1VS1分类主函数
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

%% classify
%% 方法一
model=libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
% for i=1:length(testLabel)
%     predict_label(i,1)=SVM_MultiClass_1vs1(testData(i,:),model);
% end
% acc1=length(find(predict_label==testLabel))/length(testLabel);

%% 方法二
acc2=twoClassSVM(trainData,trainLabel,testData,testLabel);


%% 原方法
[~,ACC,~]=libsvmpredict(testLabel,testData,model);

