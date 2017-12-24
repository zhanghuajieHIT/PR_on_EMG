%% 杨威数据处理

clc;
clear;
load('C:\Users\zhj\Desktop\internet data\yw\fulldata.mat');

if ~exist('Data24.mat','file')
for i=1:length(data_full)%共24组实验
    Data=[];
    Label=[];
    for j=2:10%共9个动作
        startIndex=data_full{1, i}.section{1, j}.label(1,1);
        endIndex=data_full{1, i}.section{1, j}.label(end,1);
        [rowStartIndex,~]=find(data_full{1, i}.section{1, j}.emg(:,1)==startIndex);
        [rowEndIndex,~]=find(data_full{1, i}.section{1, j}.emg(:,1)==endIndex);
        data=data_full{1, i}.section{1, j}.emg(rowStartIndex:rowEndIndex,2:9);%8通道
        %% 数据滤波
        data=filterMain(data,20,500,8);
        
        %% 数据分割
        overlap=200;
        len=300;
        NUM=fix((length(data)-len)/(len-overlap)+1);
        rowData=zeros(len,8,NUM);
        rowLabel=zeros(NUM,1);
        for k=1:NUM
            rowData(:,:,k)=data(1+(k-1)*(len-overlap):len+(k-1)*(len-overlap),:);
            rowLabel(k)=j-1;
        end
     Data=cat(3,Data,rowData);
     Label=cat(1,Label,rowLabel);
    end
    save(['Data',num2str(i),'.mat'],'Data');
    save(['Label',num2str(i),'.mat'],'Label');  
end
end

%已经保存数据的情况下
%% 特征提取
fun='feature_gnDFTR';%可以修改提取特征的函数
%训练数据
trainRawEMG=[];
trainRawLabel=[];
for i=1:16
    load(['Data',num2str(i),'.mat']);
    load(['Label',num2str(i),'.mat']);
    trainRawEMG=cat(3,trainRawEMG,Data);
    trainRawLabel=cat(1,trainRawLabel,Label);    
end
for i=1:size(trainRawEMG,3)
    trainData(i,:)=feval(fun,trainRawEMG(:,:,i));
end
trainLabel=trainRawLabel;
trainData=mapminmax(trainData',0,5)';%归一化
%测试数据
testRawEMG=[];
testRawLabel=[];
for i=1:16
    load(['Data',num2str(i),'.mat']);
    load(['Label',num2str(i),'.mat']);
    testRawEMG=cat(3,testRawEMG,Data);
    testRawLabel=cat(1,testRawLabel,Label);    
end
for i=1:size(testRawEMG,3)
    testData(i,:)=feval(fun,testRawEMG(:,:,i));
end
testLabel=testRawLabel;
testData=mapminmax(testData',0,5)';%归一化
  
%% 分类
model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
[predict_label, acc,~] = libsvmpredict(testLabel, testData, model);       
        