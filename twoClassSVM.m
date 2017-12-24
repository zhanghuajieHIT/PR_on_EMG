function [Acc]=twoClassSVM(trainData,trainLabel,testData,testLabel)
%% 1vs1分类
% 

%% load data
% train1=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\e1.mat');
% train2=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\e2.mat');
% train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
% train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
% test1=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\a1.mat');
% test2=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\a2.mat');
% test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
% test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
% fun='feature_RMS';%可以修改提取特征的函数
% trainLen=size(train.DataStructure.rawEMG,3);
% trainData=zeros(trainLen,8);    %注意特征的列数为8，不同的特征可能不一样
% testLen=size(test.DataStructure.rawEMG,3);
% testData=zeros(testLen,8);
% for i=1:trainLen
%     trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');
% end
% trainLabel=train.DataStructure.labelID;
% trainData=mapminmax(trainData',0,5)';%归一化
% for i=1:testLen   
%     testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');
% end
% testLabel=test.DataStructure.labelID;
% testData=mapminmax(testData',0,5)';%归一化

%% 数据排序
index=unique(trainLabel);
indexNum=length(index);% indexNum=14，动作种类数
trainDataTemp=[];
trainLabelTemp=[];
for i=1:indexNum
    [row,~]=find(trainLabel==index(i));
    trainDataTemp=cat(1,trainDataTemp,trainData(row,:));
    trainLabelTemp=cat(1,trainLabelTemp,trainLabel(row));
end
trainData=trainDataTemp;
trainLabel=trainLabelTemp;

%% 训练模型
featNumOneClass=length(trainLabel)/indexNum;%每种动作的样本数
% svm的训练模型model
allModel=[];
% allModelTemp=cell(indexNum-1,indexNum);
for i=1:indexNum-1
    class1=trainData(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass,:);
    label1=trainLabel(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass,:);
    for j=i+1:indexNum
        class2=trainData(1+(j-1)*featNumOneClass:j*featNumOneClass,:);
        label2=trainLabel(1+(j-1)*featNumOneClass:j*featNumOneClass,:);
        trainDataNew=[class1;class2];
        trainLabelNew=[label1;label2];
        model = libsvmtrain(trainLabelNew, trainDataNew, '-c 32 -g 0.01');
        allModel=cat(2,allModel,model);
%         allModelTemp{i,j}=model;%其实allModel可以用此代替
    end   
end

%% 测试，投票表决
modelNum=length(allModel);
predictResult=[];
combTemp=[13,12,11,10,9,8,7,6,5,4,3,2,1];
featNum=size(testData,1);
for i=1:featNum
    testDataNew=testData(i,:);
    testLabelNew=testLabel(i,:);
    voteLabel=zeros(14,1);
    resultTemp=zeros(modelNum,1);
    for j=1:modelNum
        [predictLabel, ~,~] = libsvmpredict(testLabelNew, testDataNew, allModel(j));
        voteLabel(predictLabel)=voteLabel(predictLabel)+1;
        resultTemp(j)=predictLabel;
    end
    
    [labelNum,maxClass]=max(voteLabel);%投票得到的结果

%% 改进，对于投票数最多的两类重新训练分类
%----------------------------------------------
%     trainX=[];
%     testY=[];
%     [~,maybeFault]=sort(voteLabel,'descend');
%     for ii=1:2
%         trainX=cat(1,trainX,trainData(1+(maybeFault(ii)-1)*featNumOneClass:maybeFault(ii)*featNumOneClass,:));
%         testY=cat(1,testY,trainLabel(1+(maybeFault(ii)-1)*featNumOneClass:maybeFault(ii)*featNumOneClass,:));
%     end
%     model = libsvmtrain(testY, trainX, '-c 32 -g 0.01');
%     [maxClass, ~,~] = libsvmpredict(testLabelNew, testDataNew, model);
%%------------------------------------------------------
    %% 出现投票结果相同的情况
    [maxLabelNum,~]=find(voteLabel==labelNum);
    repeatNum=length(maxLabelNum);
    if repeatNum==2 %分类结果中有两类的票数一致
        %二分类
        maxClass=resultTemp(sum(combTemp(1:maxLabelNum(1)-1))+maxLabelNum(2)-maxLabelNum(1));
    elseif repeatNum>3  %分类结果中超过两类的票数一致           
        %多分类
            trainX=[];
            testY=[];
            for ii=1:repeatNum
                trainX=cat(1,trainX,trainData(1+(maxLabelNum(ii)-1)*featNumOneClass:maxLabelNum(ii)*featNumOneClass,:));
                testY=cat(1,testY,trainLabel(1+(maxLabelNum(ii)-1)*featNumOneClass:maxLabelNum(ii)*featNumOneClass,:));
%                 model = libsvmtrain(testY, trainX, '-c 32 -g 0.01');
%                 [maxClass, ~,~] = libsvmpredict(testLabelNew, testDataNew, model);
            end
            model = libsvmtrain(testY, trainX, '-c 32 -g 0.01');
            [maxClass, ~,~] = libsvmpredict(testLabelNew, testDataNew, model);
    end
     
    predictResult=cat(1,predictResult,maxClass);
end

%% 计算正确率
Acc=length(find(predictResult==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(Acc*100),'%%\n']);

