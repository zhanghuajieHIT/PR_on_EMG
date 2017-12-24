function [Acc]=twoClassSVM(trainData,trainLabel,testData,testLabel)
%% 1vs1����
% 

%% load data
% train1=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\e1.mat');
% train2=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\e2.mat');
% train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
% train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
% test1=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a1.mat');
% test2=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a2.mat');
% test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
% test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
% fun='feature_RMS';%�����޸���ȡ�����ĺ���
% trainLen=size(train.DataStructure.rawEMG,3);
% trainData=zeros(trainLen,8);    %ע������������Ϊ8����ͬ���������ܲ�һ��
% testLen=size(test.DataStructure.rawEMG,3);
% testData=zeros(testLen,8);
% for i=1:trainLen
%     trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');
% end
% trainLabel=train.DataStructure.labelID;
% trainData=mapminmax(trainData',0,5)';%��һ��
% for i=1:testLen   
%     testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');
% end
% testLabel=test.DataStructure.labelID;
% testData=mapminmax(testData',0,5)';%��һ��

%% ��������
index=unique(trainLabel);
indexNum=length(index);% indexNum=14������������
trainDataTemp=[];
trainLabelTemp=[];
for i=1:indexNum
    [row,~]=find(trainLabel==index(i));
    trainDataTemp=cat(1,trainDataTemp,trainData(row,:));
    trainLabelTemp=cat(1,trainLabelTemp,trainLabel(row));
end
trainData=trainDataTemp;
trainLabel=trainLabelTemp;

%% ѵ��ģ��
featNumOneClass=length(trainLabel)/indexNum;%ÿ�ֶ�����������
% svm��ѵ��ģ��model
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
%         allModelTemp{i,j}=model;%��ʵallModel�����ô˴���
    end   
end

%% ���ԣ�ͶƱ���
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
    
    [labelNum,maxClass]=max(voteLabel);%ͶƱ�õ��Ľ��

%% �Ľ�������ͶƱ��������������ѵ������
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
    %% ����ͶƱ�����ͬ�����
    [maxLabelNum,~]=find(voteLabel==labelNum);
    repeatNum=length(maxLabelNum);
    if repeatNum==2 %���������������Ʊ��һ��
        %������
        maxClass=resultTemp(sum(combTemp(1:maxLabelNum(1)-1))+maxLabelNum(2)-maxLabelNum(1));
    elseif repeatNum>3  %�������г��������Ʊ��һ��           
        %�����
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

%% ������ȷ��
Acc=length(find(predictResult==testLabel))/length(testLabel);
fprintf(['Accuracy=',num2str(Acc*100),'%%\n']);

