%% �Լ�д��1VS1����������
clc;
clear;

%% load data
floderPath='H:\��������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
FUN='feature_DFT_MAV2';%�����޸���ȡ�����ĺ���
dataTrainName='a1a2';
dataTestName='b1b2';
load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat']);
trainData=featSaved(:,1:end-1);
trainData=real(trainData);
trainData=mapminmax(trainData',0,5)';%��һ��
trainLabel=featSaved(:,end);
load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTestName,'.mat']);
testData=featSaved(:,1:end-1);
testData=real(testData);
testData=mapminmax(testData',0,5)';%��һ��
testLabel=featSaved(:,end);

%% classify
%% ����һ
model=libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
% for i=1:length(testLabel)
%     predict_label(i,1)=SVM_MultiClass_1vs1(testData(i,:),model);
% end
% acc1=length(find(predict_label==testLabel))/length(testLabel);

%% ������
acc2=twoClassSVM(trainData,trainLabel,testData,testLabel);


%% ԭ����
[~,ACC,~]=libsvmpredict(testLabel,testData,model);

