%% ��������EMG����
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
%% �����˲�����
train_data=filterMain(train_data,20,500,12);

test_data=filterMain(test_data,20,500,12);

%% ����������
indexTrain=unique(train_label);
indexTrainNum=length(indexTrain);% indexNum=50������������
indexTest=unique(test_label);
indexTestNum=length(indexTest);% indexNum=50������������
train_dataTemp=[];
train_labelTemp=[];
test_dataTemp=[];
test_labelTemp=[];
% ѵ������
for i=1:indexTrainNum
    [row,~]=find(train_label==indexTrain(i));
    train_dataTemp=cat(1,train_dataTemp,train_data(row,:));
    train_labelTemp=cat(1,train_labelTemp,train_label(row));
end
train_data=train_dataTemp;
train_label=train_labelTemp;
% ��������
for i=1:indexTestNum
   [row,~]=find(test_label==indexTest(i));
   test_dataTemp=cat(1,test_dataTemp,test_data(row,:));
   test_labelTemp=cat(1,test_labelTemp,test_label(row));
end
test_data=test_dataTemp;
test_label=test_labelTemp;

%% ���ݷָ�
overlap=100;
len=300;
trainRawEMG=[];
trainRawLabel=[];
testRawEMG=[];
testRawLabel=[];

for i=1:50
    %ѵ�����ݷָ�
    [segRowTrain,~]=find(train_label==indexTrain(i));
    data_len=length(segRowTrain);%ÿһ�ֶ������ݵĳ���
    j=fix((data_len-len)/(len-overlap)+1);%�и��ÿ�ֶ������ݵķ���,���ڶ�������ݻ�����
    trainRawEMGTemp=zeros(len,12,j);
%     trainRawLabelTemp=ones(j,1)*train_label(data_len*(i-1)+1);%ע�⣬data_len�ĳ��Ȳ���ÿ�ζ���ͬ��������ô��
    trainRawLabelTemp=ones(j,1)*train_label(1);
    train_label(segRowTrain)=[];
    for k=1:j
%         trainRawEMGTemp(:,:,k)=train_data(1+(k-1)*overlap+data_len*(i-1):len+(k-1)*overlap+data_len*(i-1),:);
        trainRawEMGTemp(:,:,k)=train_data(1+(k-1)*(len-overlap):len+(k-1)*(len-overlap),:);
    end
    train_data(segRowTrain,:)=[];
    trainRawEMG=cat(3,trainRawEMG,trainRawEMGTemp);
    trainRawLabel=cat(1,trainRawLabel,trainRawLabelTemp);
    
    %�������ݷָ�
    [segRowTest,~]=find(test_label==indexTest(i));
    data_len=length(segRowTest);%ÿһ�ֶ������ݵĳ���
    j=fix((data_len-len)/(len-overlap)+1);%�и��ÿ�ֶ������ݵķ���,���ڶ�������ݻ�����
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
% ����ָ�������
save('trainRawEMG.mat','trainRawEMG');
save('trainRawLabel.mat','trainRawLabel');
save('testRawEMG.mat','testRawEMG');
save('testRawLabel.mat','testRawLabel');
end

%% ������ȡ
if ~exist('trainRawEMG','var')
    load('trainRawEMG.mat');
    load('trainRawLabel.mat');
    load('testRawEMG.mat');
    load('testRawLabel.mat');
end

fun='feature_gnDFTR';%�����޸���ȡ�����ĺ���
trainLen=size(trainRawEMG,3);
trainData=zeros(trainLen,72);%ע������������Ϊ8����ͬ���������ܲ�һ��
testLen=size(testRawEMG,3);
testData=zeros(testLen,72);
for i=1:trainLen
    trainData(i,:)=feval(fun,trainRawEMG(:,:,i));
end
trainLabel=trainRawLabel;
trainData=mapminmax(trainData',0,5)';%��һ��
for i=1:testLen
    testData(i,:)=feval(fun,testRawEMG(:,:,i));
end
testLabel=testRawLabel;
testData=mapminmax(testData',0,5)';%��һ��
%��������
save('feature_gnDFTR_TrainData.mat','trainData');
save('feature_gnDFTR_TrainLabel.mat','trainLabel');
save('feature_gnDFTR_TestData.mat','testData');
save('feature_gnDFTR_TestLabel.mat','testLabel');

%% ����
model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
[predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
