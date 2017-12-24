%% 网上下载EMG处理
%% load data
clear;
clc;
if ~exist('trainRawEMG.mat','file')
folderPath='C:\Users\zhj\Desktop\internet data';
dirOut=dir(fullfile(folderPath,'*.mat'));
train_label=[];
train_data=[];
test_label=[];
test_data=[];
for i=1:length(dirOut)
    load(fullfile(folderPath,dirOut(i).name));
    [test_row1,~]=find(rerepetition==2);
    [test_row2,~]=find(rerepetition==5);
    test_data=cat(1,test_data,emg([test_row1;test_row2],:));
    test_label=cat(1,test_label,restimulus([test_row1;test_row2],:));
    emg([test_row1;test_row2],:)=[];
    restimulus([test_row1;test_row2],:)=[];
    train_data=cat(1,train_data,emg);
    train_label=cat(1,train_label,restimulus);
end
train_label=double(train_label);
test_label=double(test_label);
%% 数据滤波处理
train_data=filterMain(train_data,20,500,12);

test_data=filterMain(test_data,20,500,12);

%% 数据重排序
indexTrain=unique(train_label);
indexTrainNum=length(indexTrain);% indexNum=50，动作种类数
indexTest=unique(test_label);
indexTestNum=length(indexTest);% indexNum=50，动作种类数
train_dataTemp=[];
train_labelTemp=[];
test_dataTemp=[];
test_labelTemp=[];
% 训练数据
for i=1:indexTrainNum
    [row,~]=find(train_label==indexTrain(i));
    train_dataTemp=cat(1,train_dataTemp,train_data(row,:));
    train_labelTemp=cat(1,train_labelTemp,train_label(row));
end
train_data=train_dataTemp;
train_label=train_labelTemp;
% 测试数据
for i=1:indexTestNum
   [row,~]=find(test_label==indexTest(i));
   test_dataTemp=cat(1,test_dataTemp,test_data(row,:));
   test_labelTemp=cat(1,test_labelTemp,test_label(row));
end
test_data=test_dataTemp;
test_label=test_labelTemp;

%% 数据分割
overlap=100;
len=300;
trainRawEMG=[];
trainRawLabel=[];
testRawEMG=[];
testRawLabel=[];

for i=1:50
    %训练数据分割
    [segRowTrain,~]=find(train_label==indexTrain(i));
    data_len=length(segRowTrain);%每一种动作数据的长度
    j=fix((data_len-len)/(len-overlap)+1);%切割后每种动作数据的份数,对于多余的数据会舍弃
    trainRawEMGTemp=zeros(len,12,j);
%     trainRawLabelTemp=ones(j,1)*train_label(data_len*(i-1)+1);%注意，data_len的长度不是每次都相同，不能这么用
    trainRawLabelTemp=ones(j,1)*train_label(1);
    train_label(segRowTrain)=[];
    for k=1:j
%         trainRawEMGTemp(:,:,k)=train_data(1+(k-1)*overlap+data_len*(i-1):len+(k-1)*overlap+data_len*(i-1),:);
        trainRawEMGTemp(:,:,k)=train_data(1+(k-1)*(len-overlap):len+(k-1)*(len-overlap),:);
    end
    train_data(segRowTrain,:)=[];
    trainRawEMG=cat(3,trainRawEMG,trainRawEMGTemp);
    trainRawLabel=cat(1,trainRawLabel,trainRawLabelTemp);
    
    %测试数据分割
    [segRowTest,~]=find(test_label==indexTest(i));
    data_len=length(segRowTest);%每一种动作数据的长度
    j=fix((data_len-len)/(len-overlap)+1);%切割后每种动作数据的份数,对于多余的数据会舍弃
    testRawEMGTemp=zeros(len,12,j);
%     testRawLabelTemp=ones(j,1)*test_label(data_len*(i-1)+1);
    testRawLabelTemp=ones(j,1)*test_label(1);
    test_label(segRowTest)=[];
    for k=1:j
%         testRawEMGTemp(:,:,k)=test_data(1+(k-1)*overlap+data_len*(i-1):len+(k-1)*overlap+data_len*(i-1),:);
        testRawEMGTemp(:,:,k)=test_data(1+(k-1)*(len-overlap):len+(k-1)*(len-overlap),:);
    end
    test_data(segRowTest,:)=[];
    testRawEMG=cat(3,testRawEMG,testRawEMGTemp);
    testRawLabel=cat(1,testRawLabel,testRawLabelTemp);
end
% 保存分割后的数据
save('trainRawEMG.mat','trainRawEMG');
save('trainRawLabel.mat','trainRawLabel');
save('testRawEMG.mat','testRawEMG');
save('testRawLabel.mat','testRawLabel');
end

%% 特征提取
if ~exist('trainRawEMG','var')
    load('trainRawEMG.mat');
    load('trainRawLabel.mat');
    load('testRawEMG.mat');
    load('testRawLabel.mat');
end

fun='feature_gnDFTR';%可以修改提取特征的函数
trainLen=size(trainRawEMG,3);
trainData=zeros(trainLen,72);%注意特征的列数为8，不同的特征可能不一样
testLen=size(testRawEMG,3);
testData=zeros(testLen,72);
for i=1:trainLen
    trainData(i,:)=feval(fun,trainRawEMG(:,:,i));
end
trainLabel=trainRawLabel;
trainData=mapminmax(trainData',0,5)';%归一化
for i=1:testLen
    testData(i,:)=feval(fun,testRawEMG(:,:,i));
end
testLabel=testRawLabel;
testData=mapminmax(testData',0,5)';%归一化
%保存特征
save('feature_gnDFTR_TrainData.mat','trainData');
save('feature_gnDFTR_TrainLabel.mat','trainLabel');
save('feature_gnDFTR_TestData.mat','testData');
save('feature_gnDFTR_TestLabel.mat','testLabel');

%% 分类
model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
[predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
