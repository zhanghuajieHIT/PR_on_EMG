%% DBN for delsysData

clc;
clear;

floderPath='H:\特征保存\zhj20161219\无归一化预处理后，overlap为100,len为300';
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

TotalAcc=[];%用于记录所有特征的最后结果
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
Acc=[];%用于保存所有的正确率
Acc2=[];
for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%确定训练数据
    trainData=[];
    for k=1:length(funName)%加载训练数据
        FUN=cell2mat(funName(k));
        if exist(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
            load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label都是一样的
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end
            trainData=cat(2,trainData,trainDataTemp);
        end
    end
    trainLabel=ind2vec(train_label')';
%     trainLabel=train_label;
    trainData=real(trainData);
    trainData=mapminmax(trainData',0,1)';%归一化
    
    rand('state',0)
    %train dbn
    dbn.sizes = [150 80];
    opts.numepochs =   500;
    opts.batchsize = 10;
    opts.momentum  =   0.001;
    opts.alpha     =   2;
    dbn = dbnsetup(dbn, trainData, opts);
    dbn = dbntrain(dbn, trainData, opts);
    
    nn = dbnunfoldtonn(dbn, 14);
    nn.activation_function = 'sigm';
    
    opts.numepochs =  1;
    opts.batchsize = 10;
      
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
            if exist(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label都是一样的
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'-thresh.mat']);
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=cat(2,testData,testDataTemp);
            end
        end
        testLabel=ind2vec(test_label')';
%         testLabel=test_label;
        testData=real(testData);
        testData=mapminmax(testData',0,1)';%归一化
        
        %% 分类
        nn = nntrain(nn, trainData, trainLabel, opts);
        [er, ~] = nntest(nn, testData, testLabel);
        result=1-er;
                
        %% 保存所有的正确率
        Acc=cat(1,Acc,result);

    end
end

AverAcc=mean(Acc);
TotalAcc=cat(1,TotalAcc,AverAcc);
end

