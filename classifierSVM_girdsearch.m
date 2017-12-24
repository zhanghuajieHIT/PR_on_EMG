% �������������Ĳ���Ѱ�ţ�SVM����
% ����ʵ��2�����ݷ���
clc;
clear;

floderPath='C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ������overlapΪ100,lenΪ300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
% 

FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
FunName.g={'feature_DFT_MAV2','feature_DFT_DASDV','feature_WT_LOG','feature_WAMP'};

TotalAcc=[];%���ڼ�¼���������������
for featKindNum=97:97+6
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
Acc4=[];%���ڱ������е���ȷ��

for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%ȷ��ѵ������
    trainData=[];
    for k=1:length(funName)%����ѵ������
        FUN=cell2mat(funName(k));
        if exist(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
            load(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label����һ����
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTrainName,'-thresh.mat']);
            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end
            trainData=cat(2,trainData,trainDataTemp);
        end
    end
    trainLabel=train_label;
    trainData=real(trainData);
    trainData=mapminmax(trainData',0,5)';%��һ��
    
    %% ����ѵ�������в���Ѱ��
    [~,bestC,bestG] = girdsearch_SVM(trainData,trainLabel);
    evalin('base' ,['C_G.',[char(featKindNum),'_',dataTrainName],'=[bestC,bestG]']); 
    
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
            if exist(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTestName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                load(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label����һ����
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTestName,'-thresh.mat']);
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
        %------SVM------%
        cmd=['-c ',num2str(bestC),' -g ',num2str(bestG)];
        M=libsvmtrain(trainLabel,trainData,cmd);
        [~,acc,~]=libsvmpredict(testLabel,testData,M);
        accuracy4=acc(1);
        
        %% �������е���ȷ��
        Acc4=cat(1,Acc4,accuracy4);

    end
end

AverAcc4=mean(Acc4);

TotalAcc=cat(1,TotalAcc,AverAcc4);

end
