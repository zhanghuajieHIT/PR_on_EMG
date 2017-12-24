%% һֻ�ֱ۵�����ѵ������һֻ�ֱ۵����ݲ���
% �������Ƚϣ����е����ݺͷ�����һ�����
% ����ʵ��2�����ݷ���
clc;
clear;

file1='E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219';
floderPath=[file1,'\�޹�һ��Ԥ�����overlapΪ100,lenΪ300'];
file2='H:\��������\zhj20161219';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;

FunName.a={'feature_MAV1','feature_MAV1','feature_MAV2','feature_SSI','feature_RMS','feature_LOG','feature_WL','feature_DASDV','feature_VAR','feature_VORDER','feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};
% FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
FunName.g={'feature_DFT_MAV2','feature_DFT_DASDV','feature_WT_LOG','feature_WAMP'};

for featKindNum=97:97%+6
    funName=eval(['FunName.',char(featKindNum)]);

%% �����ݷ�Ϊ���ֺ�����
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

%% ��������Ϊѵ��������������Ϊ���Լ�
allDataName=[leftDataName;rightDataName];
Acc1=[];%���ڱ������е���ȷ��
Acc2=[];
Acc3=[];
Acc4=[];
Acc5=[];
Acc6=[];
Acc7=[];
for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%ȷ��ѵ������
    trainData=[];
    for k=1:length(funName)%����ѵ������
        FUN=cell2mat(funName(k));
        if exist([file2,'\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
            load([file2,'\��������\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label����һ����
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load([file2,'\��������\',FUN,'-',dataTrainName,'-thresh.mat']);
            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end
            trainData=cat(2,trainData,trainDataTemp);
        end
    end
    trainLabel=train_label;
    trainData=real(trainData);
    trainData=mapminmax(trainData',0,5)';%��һ��
    
    %% ȷ���������ݲ�����
    if i<=length(leftDataName)%ȷ����������
        startIndex=length(leftDataName)+1;
        endIndex=length(allDataName);
    else
        startIndex=1;
        endIndex=length(leftDataName);
    end
    for j=startIndex:endIndex
        dataTestName=cell2mat(allDataName(j));
        testData=[];
        for k=1:length(funName)%���ز�������
            FUN=cell2mat(funName(k));
            if exist([file2,'\��������\',FUN,'-',dataTestName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                load([file2,'\��������\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label����һ����
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load([file2,'\��������\',FUN,'-',dataTestName,'-thresh.mat']);
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=cat(2,testData,testDataTemp);
            end
        end
        testLabel=test_label;
        testData=real(testData);
        testData=mapminmax(testData',0,5)';%��һ��
                
        %% ����
        %----����Bayes----%
%         M=fitcnb(trainData,trainLabel);%Naive Bayes
%         predict_label=predict(M,testData);
%         accuracy1= length(find(predict_label == testLabel))/length(testLabel)*100;
%         %----PNN-----%
%         train_Data=trainData';
%         train_Label=trainLabel';
%         train_Label=ind2vec(train_Label);
%         test_Data=testData';
%         test_Label=testLabel';
%         net=newpnn(train_Data,train_Label,4);%ԭ��spreadΪ4
%         predictLabel=sim(net,test_Data);
%         predict_label=vec2ind(predictLabel);
%         accuracy2= length(find(predict_label == test_Label))/length(testLabel)*100;
        %------LDA-------%
        M=fitcdiscr(trainData,trainLabel,'discrimType','linear');%�б����LDA
        predict_label=predict(M,testData);
        accuracy3= length(find(predict_label == testLabel))/length(testLabel)*100;
        %------SVM------%
%         M=libsvmtrain(trainLabel,trainData,'-c 32 -g 0.01');
%         [~,acc,~]=libsvmpredict(testLabel,testData,M);
%         accuracy4=acc(1);
%         %-------KNN-----%
%         M=fitcknn(trainData,trainLabel,'NumNeighbors',4);
%         predict_label=predict(M,testData);
%         accuracy5= length(find(predict_label == testLabel))/length(testLabel)*100;
%         %------Adaboost+Tree--%
%         M=fitensemble(trainData,trainLabel,'AdaBoostM2',10,'Tree','type','classification');%����ѧϰ
%         predict_label=predict(M,testData);
%         accuracy6= length(find(predict_label == testLabel))/length(testLabel)*100;
%         %------Adaboost+LDA-----%
%         M=fitensemble(trainData,trainLabel,'AdaBoostM2',10,'Discriminant','type','classification');%����ѧϰ
%         predict_label=predict(M,testData);
%         accuracy7= length(find(predict_label == testLabel))/length(testLabel)*100;
        
        %% �������е���ȷ��
%         Acc1=cat(1,Acc1,accuracy1);
%         Acc2=cat(1,Acc2,accuracy2);
        Acc3=cat(1,Acc3,accuracy3);
%         Acc4=cat(1,Acc4,accuracy4);
%         Acc5=cat(1,Acc5,accuracy5);
%         Acc6=cat(1,Acc6,accuracy6);
%         Acc7=cat(1,Acc7,accuracy7);

    end
end
% evalin('base',['AverAcc.',[char(featKindNum),'_Acc1'],'=mean(Acc1)']);
% evalin('base',['AverAcc.',[char(featKindNum),'_Acc2'],'=mean(Acc2)']);
evalin('base',['AverAcc.',[char(featKindNum),'_Acc3'],'=mean(Acc3)']);
% evalin('base',['AverAcc.',[char(featKindNum),'_Acc4'],'=mean(Acc4)']);
% evalin('base',['AverAcc.',[char(featKindNum),'_Acc5'],'=mean(Acc5)']);
% evalin('base',['AverAcc.',[char(featKindNum),'_Acc6'],'=mean(Acc6)']);
% evalin('base',['AverAcc.',[char(featKindNum),'_Acc7'],'=mean(Acc7)']);

end

