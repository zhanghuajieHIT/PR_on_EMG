%% RVM实现多类分类的主函数
%先实现一组数据，后实现多组数据
clc;
clear; 
%% load data
load('trainEMG.mat');
load('testEMG.mat');
trainData=trainEMG(:,1:end-1);
trainData=mapminmax(trainData',0.5,1)';
trainLabel=trainEMG(:,end);
testData=testEMG(:,1:end-1);
testData=mapminmax(testData',0.5,1)';
testLabel=testEMG(:,end);
width= 0.5;
kernel='gauss';
maxIts=1000;
predictLabel=RVM_1vs1(kernel,width,maxIts,trainData,trainLabel,testData,testLabel);

% load synth.tr%导入训练数据
% synth	= synth(randperm(size(synth,1)),:);
% trainData	= synth(1:size(synth,1),1:2);%数据
% trainLabel	= synth(1:size(synth,1),3);%标签
% trainData=mapminmax(trainData',0,5)';
% load synth.te%导入测试数据
% synth	= synth(randperm(size(synth,1)),:);
% testData	= synth(1:size(synth,1),1:2);
% testLabel	= synth(1:size(synth,1),3);
% testData=mapminmax(testData',0,5)';
% model=libsvmtrain(trainLabel,trainData,'-c 32 -g 0.01');
% [predict_label,acc,~]=libsvmpredict(testLabel,testData,model);
