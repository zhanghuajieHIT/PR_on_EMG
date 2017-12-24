% clear;
% clc;
% 
% floderPath='E:\实验主机2\z师兄\zhj20161219\无归一化预处理后，overlap为100,len为300';
% FUN='feature_DFT_MAV2';%可以修改提取特征的函数
% 
% dataTrainName='c1c2';
% dataTestName='d1d2';
% load(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat']);
% trainData=featSaved(:,1:end-1);
% trainData=mapminmax(trainData',0,5)';%归一化
% trainLabel=featSaved(:,end);
% load(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat']);
% testData=featSaved(:,1:end-1);
% testData=mapminmax(testData',0,5)';%归一化
% testLabel=featSaved(:,end);
% %% classify
% [result1,result2]=yangDataSAE_Three(trainData',trainLabel,testData',testLabel,dataTrainName,FUN); 
% % [result1,result2]=yangDataSAE_Two(trainData',trainLabel,testData',testLabel,dataTrainName,FUN); 


% 课题实验2的数据分类
clc;
clear;

floderPath='E:\实验主机2\z师兄\zhj20161219\无归一化预处理后，overlap为100,len为300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;

FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
FunName.g={'feature_DFT_MAV2','feature_DFT_DASDV','feature_WT_LOG','feature_WAMP'};

TotalAcc1=[];%用于记录所有特征的最后结果
TotalAcc2=[];
for featKindNum=101:101%+6
    funName=eval(['FunName.',char(featKindNum)]);

%% 把数据分为左手和右手
rowLeft=0;
rowRight=0;
leftDataName=cell(num/(2*repeatNum),1);
rightDataName=cell(num/(2*repeatNum),1);
for i=1:repeatNum:num
    if mod(i,2*repeatNum)==1
        rowLeft=rowLeft+1;
        for j=0:repeatNum-1
            leftDataName(rowLeft,1)=strcat(leftDataName(rowLeft,1),dirout(i+j).name(1:2));
        end
    else
        rowRight=rowRight+1;
        for j=0:repeatNum-1
            rightDataName(rowRight,1)=strcat(rightDataName(rowRight,1),dirout(i+j).name(1:2));
        end
    end
end

%% 左手数据为训练集，右手数据为测试集
allDataName=[leftDataName;rightDataName];
Acc1=[];%用于保存所有的正确率
Acc2=[];
for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%确定训练数据
    trainData=[];
    for k=1:length(funName)%加载训练数据
        FUN=cell2mat(funName(k));
        if exist(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
            load(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label都是一样的
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end
            trainData=cat(2,trainData,trainDataTemp);
        end
    end
    trainLabel=train_label;
    trainData=real(trainData);
    trainData=mapminmax(trainData',0,5)';%归一化
      
    %% 确定测试数据并加载
    if i<=length(leftDataName)%确定测试数据
        startIndex=length(leftDataName)+1;
        endIndex=length(allDataName);
    else
        startIndex=1;
        endIndex=length(leftDataName);
    end
    for j=startIndex:endIndex
        dataTestName=cell2mat(allDataName(j));
        testData=[];
        for k=1:length(funName)%加载测试数据
            FUN=cell2mat(funName(k));
            if exist(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                load(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label都是一样的
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load(['E:\实验主机2\z师兄\zhj20161219\特征保存\',FUN,'-',dataTestName,'-thresh.mat']);
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=cat(2,testData,testDataTemp);
            end
        end
        testLabel=test_label;
        testData=real(testData);
        testData=mapminmax(testData',0,5)';%归一化
                
        %% 分类
        [result1,result2]=yangDataSAE_Two(trainData',trainLabel,testData',testLabel,dataTrainName,FUN); 
%         [result1,result2]=yangDataSAE_Three(trainData',trainLabel,testData',testLabel,dataTrainName,FUN); 
        %% 保存所有的正确率
        Acc1=cat(1,Acc1,result1);
        Acc2=cat(1,Acc2,result2);

    end
end

AverAcc1=mean(Acc1);
AverAcc2=mean(Acc2);
TotalAcc1=cat(1,TotalAcc1,AverAcc1);
TotalAcc2=cat(1,TotalAcc2,AverAcc2);
end

