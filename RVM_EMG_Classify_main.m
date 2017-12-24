%% RVMʵ�ֶ�������������
%��ʵ��һ�����ݣ���ʵ�ֶ�������
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

% load synth.tr%����ѵ������
% synth	= synth(randperm(size(synth,1)),:);
% trainData	= synth(1:size(synth,1),1:2);%����
% trainLabel	= synth(1:size(synth,1),3);%��ǩ
% trainData=mapminmax(trainData',0,5)';
% load synth.te%�����������
% synth	= synth(randperm(size(synth,1)),:);
% testData	= synth(1:size(synth,1),1:2);
% testLabel	= synth(1:size(synth,1),3);
% testData=mapminmax(testData',0,5)';
% model=libsvmtrain(trainLabel,trainData,'-c 32 -g 0.01');
% [predict_label,acc,~]=libsvmpredict(testLabel,testData,model);
