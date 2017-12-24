clc;
clear;

file='D:\MatWorkSpace\杨老师数据\EMG data.mat';
load(file);

%% 去均值,均值约为1.2
for i=1:length(DataStructure)%i从1到9
    DataStructure{1,i}.rawEMG=DataStructure{1,i}.rawEMG-1.2;
end

%% 归一化
%训练数据
len=0;
for k=1:5   %
   len=len+length(DataStructure{1,k}.rawEMG);
end
train_data=zeros(8,256,len);
train_label=zeros(len,1);
Len1=0;
Len2=0;
for j=1:5   %
    Len1=Len2;
    Len2=Len2+length(DataStructure{1,j}.rawEMG);
    k=1+Len1;
    for i=1:Len2-Len1
        train_data(:,:,k)=mapminmax(DataStructure{1,j}.rawEMG(:,:,i),0,1); 
        train_label(1+Len1:Len2,1)=DataStructure{1,j}.labelID;
        k=k+1;
    end
    
end

[~,~,numTrain]=size(train_data);
trainData=zeros(2048,numTrain);
trainLabels=zeros(numTrain,1);%7种动作
for i=1:numTrain%训练的数据数量
    rowID=randi(numTrain);
    trainData(:,i)=reshape(train_data(:,:,rowID),2048,1);%8*256的输入格式
    trainLabels(i)=train_label(rowID);
end


%测试数据，并训练
result=[];
for j=5:9
    test_data=zeros(8,256,length(DataStructure{1,j}.rawEMG));
    for k=1:length(DataStructure{1,j}.rawEMG)
        test_data(:,:,k)=mapminmax(DataStructure{1,j}.rawEMG(:,:,k),0,1); 
    end
    
    [~,~,numTest]=size(test_data);
    testData=zeros(2048,numTest);
    testLabels=zeros(numTest,1);
    for i=1:numTest
        rowID=randi(numTest);
        testData(:,i)=reshape(test_data(:,:,rowID),2048,1);
        testLabels(i)=DataStructure{1,j}.labelID(rowID);
    end
    
    %训练和测试
    [result1,result2]=yangDataSAE_Two(trainData,trainLabels,testData,testLabels);
%     [result1,result2]=yangDataSAE_Three(trainData,trainLabels,testData,testLabels);
    result=[result;result1;result2];  
end

%% 输出结果
j=1;
for i=6:9
    fprintf(['Train:data1-data5,    Test:data',num2str(i),'\n']);
    fprintf('Before Finetuning Test Accuracy: %0.3f%%\n', result(j)*100);
    fprintf('After Finetuning Test Accuracy: %0.3f%%\n', result(j+1)*100);
    j=j+2;
end

