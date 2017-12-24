%% 提取特征的主函数
% 针对SAE
% by zhj
% 2016/11/27
%=========================%
clc;
clear;
%% 加载数据
data1=load('E:\实验\Delsys数据采集\实验数据\zhj20161206\无归一化预处理后，overlap为100,len为300\a1.mat');
data2=load('E:\实验\Delsys数据采集\实验数据\zhj20161206\无归一化预处理后，overlap为100,len为300\a2.mat');
% data3=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\归一化预处理后，overlap为128,len为256\a3.mat');
dataTrain.DataStructure.rawEMG=cat(3,data1.DataStructure.rawEMG,data2.DataStructure.rawEMG);
dataTrain.DataStructure.labelID=cat(1,data1.DataStructure.labelID,data2.DataStructure.labelID);
dataTrain.DataStructure.classname=cat(1,data1.DataStructure.classname,data2.DataStructure.classname);
dataTest=load('E:\实验\Delsys数据采集\实验数据\zhj20161206\无归一化预处理后，overlap为100,len为300\a3.mat');

%% 归一化
numTrain=size(dataTrain.DataStructure.rawEMG,3);
numTest=size(dataTest.DataStructure.rawEMG,3);

% for i=1:numTrain
%     dataTrain.DataStructure.rawEMG(:,:,i)=mapminmax(dataTrain.DataStructure.rawEMG(:,:,i),0,1); 
% end
% for i=1:numTest
%     dataTest.DataStructure.rawEMG(:,:,i)=mapminmax(dataTest.DataStructure.rawEMG(:,:,i),0,1); 
% end
    
trainData=zeros(2400,numTrain);
% trainData=zeros(256,numTrain);
trainLabels=zeros(numTrain,1);
testData=zeros(2400,numTest);
% testData=zeros(256,numTest);
testLabels=zeros(numTest,1);
trainIndex=randperm(numTrain);
testIndex=randperm(numTest);
for i=1:numTrain%训练的数据数量
%     rowID=trainIndex(i);
     rowID=i;
%     trainData(:,i)=reshape(dataTrain.DataStructure.rawEMG(1,:,rowID),256,1);
    trainData(:,i)=reshape(dataTrain.DataStructure.rawEMG(:,:,rowID),2400,1);%8*256的输入格式
    trainLabels(i)=dataTrain.DataStructure.labelID(rowID);
end
for i=1:numTest%测试的数据数量
%     rowID=testIndex(i);
    rowID=i;
%     testData(:,i)=reshape(dataTest.DataStructure.rawEMG(1,:,rowID),256,1);
    testData(:,i)=reshape(dataTest.DataStructure.rawEMG(:,:,rowID),2400,1);
    testLabels(i)=dataTest.DataStructure.labelID(rowID);
end

%% 特征提取
% trainSparseFeature=zeros(10,numTrain);
% for i=1:10
%     trainSparseFeature(:,i)=feature_SAE(trainData(:,i));
% end
% testSparseFeature=zeros(10,numTest);
% for i=1:numTest
%     testSparseFeature(:,i)=feature_SAE(testData(:,i));
% end

trainSparseFeature=feature_SAE(trainData);
testSparseFeature=feature_SAE(testData);

save('E:\MatWorkSpace\特征保存\trainSparseFeature_a1a2.mat','trainSparseFeature');
save('E:\MatWorkSpace\特征保存\trainLabels_a1a2.mat','trainLabels');
save('E:\MatWorkSpace\特征保存\testSparseFeature_a3.mat','testSparseFeature');
save('E:\MatWorkSpace\特征保存\testLabels_a3.mat','testLabels');
