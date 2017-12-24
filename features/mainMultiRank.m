%% ��֤��׼�������ںϷ���
% �ںϵ�Ȩֵ����ʵ�����ݻ��д��Ľ�

clc;
clear;

floderPath='E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
hand=2;
xlsFileName='E:\ʵ��\Delsys���ݲɼ�\ʵ���¼\ʵ���¼.xlsx';
experimentTime='zhj20170104';
funName={'feature_MAV','feature_RMS','feature_WL','feature_SSC','feature_ZC',...
    'feature_MYOP','feature_WAMP','feature_DASDV','feature_WCM','feature_WCSVD',...
    'feature_WPCM','feature_WPCSVD'};
featTotalNum=length(funName);
fun=cell(1,featTotalNum);
for i=1:featTotalNum
    fun{i}.name=funName{i};
    if strcmp(fun{i}.name,'feature_WCE')||strcmp(fun{i}.name,'feature_WCM')||strcmp(fun{i}.name,'feature_WCSVD')
        fun{i}.featCol=48; 
    elseif strcmp(fun{i}.name,'feature_WPCE')||strcmp(fun{i}.name,'feature_WPCM')||strcmp(fun{i}.name,'feature_WPCSVD')
        fun{i}.featCol=64;
    elseif strcmp(fun{i}.name,'feature_HIST')
        fun{i}.featCol=72;
    elseif strcmp(fun{i}.name,'feature_AR')||strcmp(fun{i}.name,'feature_CC')
        fun{i}.featCol=40;
    elseif strcmp(fun{i}.name,'feature_MAVS')
        fun{i}.featCol=7;
    elseif strcmp(fun,'feature_DRMS')
        fun{i}.featCol=15;
    elseif strcmp(fun,'feature_DRMS2')
        fun{i}.featCol=16;
    else
        fun{i}.featCol=8;%����������
    end
end

%% �������
featFusionNum=featTotalNum;%��ϵ�������Ŀ
featFusion=nchoosek(fun,featFusionNum);%�������
featNum=size(featFusion,1);%������Ϻ�õ���������Ŀ
accuracy=[];
for NUM=1:featNum
    [~,text]=xlsread(xlsFileName,experimentTime);
    row=size(text,1);
    featLoc=['A',num2str(row+1)];%����������xls�ļ��е�λ��
    featName={};
    featTotalCol= 0;
    for i=1:featFusionNum
       featName= cat(2,featName,featFusion{NUM,i}.name(9:end));
       featTotalCol= featTotalCol+featFusion{NUM,i}.featCol;
    end
    xlswrite(xlsFileName,featName,experimentTime,featLoc);%�����������������
    
    for start=1:hand %2��ָ�����ֶ��ɼ�����,������ֲɼ��Ļ����Ϊ1
        Acc=[];%���ڱ�������
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            train.DataStructure.rawEMG=[];
            train.DataStructure.labelID=[];
            dataTrainNameTemp=[];
            for k=0:repeatNum-1
                trainTemp=load(fullfile(floderPath,dirout(i+k).name));
                train.DataStructure.rawEMG=cat(3,train.DataStructure.rawEMG,trainTemp.DataStructure.rawEMG);
                train.DataStructure.labelID=cat(1,train.DataStructure.labelID,trainTemp.DataStructure.labelID);
                dataTrainNameTemp=strcat(dataTrainNameTemp,dirout(i+k).name(1:2));
            end
            dataName=cat(2,dataName,dataTrainNameTemp);
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                test.DataStructure.rawEMG=[];
                test.DataStructure.labelID=[];
                dataTestNameTemp=[];
                for m=0:repeatNum-1
                    testTemp=load(fullfile(floderPath,dirout(j+m).name));
                    test.DataStructure.rawEMG=cat(3,test.DataStructure.rawEMG,testTemp.DataStructure.rawEMG);
                    test.DataStructure.labelID=cat(1,test.DataStructure.labelID,testTemp.DataStructure.labelID);
                    dataTestNameTemp=strcat(dataTestNameTemp,dirout(j+m).name(1:2));
                end   
 
                trainData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k}.name;
                    if exist(['H:\��������\zhj20161219\',FUN,'-',dataTrainNameTemp,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                        load(['H:\��������\zhj20161219\',FUN,'-',dataTrainNameTemp,'.mat']);
                        trainData=cat(2,trainData,featSaved);
                    else
                        trainLen=size(train.DataStructure.rawEMG,3);
                        trainDataTemp=[];
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train.DataStructure.rawEMG(:,:,n)'));
                        end
                        trainData=cat(2,trainData,trainDataTemp);
                        featSaved=trainDataTemp;
                        save(['H:\��������\zhj20161219\',FUN,'-',dataTrainNameTemp,'.mat'],'featSaved');
                    end
                                                                   
                end
                trainLabel=train.DataStructure.labelID;
                trainData=mapminmax(trainData',0,5)';%��һ��
        
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k}.name;
                    if exist(['H:\��������\zhj20161219\',FUN,'-',dataTestNameTemp,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                        load(['H:\��������\zhj20161219\',FUN,'-',dataTestNameTemp,'.mat']);
                        testData=cat(2,testData,featSaved);
                    else
                        testLen=size(test.DataStructure.rawEMG,3);
                        testDataTemp=[];
                        for n=1:testLen
                            testDataTemp=cat(1,testDataTemp,feval(FUN,test.DataStructure.rawEMG(:,:,n)'));
                        end
                        testData=cat(2,testData,testDataTemp);
                        featSaved=testDataTemp;
                        save(['H:\��������\zhj20161219\',FUN,'-',dataTestNameTemp,'.mat'],'featSaved');
                    end
                                                                   
                end
                testLabel=test.DataStructure.labelID;
                testData=mapminmax(testData',0,5)';%��һ��
                
                %% ��������ֵ
                A_Relieff=FSReliefF(trainData,trainLabel);
                A_Fisher=FisherRatio(trainData,trainLabel);
                A_MDistance=MDistance(trainData,trainLabel);
                
                %% ��׼�������ں�
                fusionSort=A_Relieff+A_Fisher+A_MDistance;%�ںϵ�Ȩֵ����ʵ�����ݻ��д��Ľ�
                [~,newSort]=sort(fusionSort);%����
                Acc=[];
                for ii=length(newSort):-1:1
                    trainDataNew=trainData(:,newSort(1:ii));
                    trainLabelNew=trainLabel;
                    testDataNew=testData(:,newSort(1:ii));
                    testLabelNew=testLabel;
                    model = libsvmtrain(trainLabelNew, trainDataNew, '-c 32 -g 0.01');
                    [predict_label, acc,~] = libsvmpredict(testLabelNew, testDataNew, model);
                    Acc=cat(1,Acc,acc(1));
                end
                accuracy=cat(2,accuracy,Acc);
%                 model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
%                 [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
%                 Acc=cat(1,Acc,acc(1));
                
%             %% pca��ά
%                 trainDataPCA=PCA_opt(trainData,0.95);%ԭ���������İٷֱ�
%                 testDataPCA=PCA_opt(testData,0.95);
%                % ��һ����Ч������
%                 trainDataPCA=mapminmax(trainDataPCA',0,5)';
%                 testDataPCA=mapminmax(testDataPCA',0,5)';               
%                 model = libsvmtrain(trainLabel, trainDataPCA, '-c 32 -g 0.01');
%                 [predict_label, acc,~] = libsvmpredict(testLabel, testDataPCA, model);
%                 Acc=cat(1,Acc,acc(1));
        
            end
    
        end
        
%         %% ���ݱ��浽xls�ļ���
%         [~,text]=xlsread(xlsFileName,experimentTime);
%         row=size(text,1);
%         rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
%         colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
%         resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
%         result=reshape(Acc,3,3)';
%         xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
%         xlswrite(xlsFileName,dataName',experimentTime,colLoc);
%         xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

    end
    
end

% fprintf('������ɣ�������������ȷ�ʾ�ֵ�����档\n');

%% �����ֵ������
% result=readData(experimentTime,xlsFileName);

% fprintf('��ֵ������ɡ�\n');
%% ��������ֵ
% A_Relieff=FSReliefF(trainData,trainLabel);
% A_Fisher=FisherRatio(trainData,trainLabel);
% A_MDistance=MDistance(trainData,trainLabel);

%% ��һ׼��







%% ��׼�������ں�
% ������ϵĲ�����Ҫ����
% fusionSort=A_Relieff+A_Fisher+A_MDistance;
% [~,newSort]=sort(fusionSort);%����
% Acc=[];
% for i=length(newSort):-1:1
% trainDataNew=trainData(:,newSort(1:i));
% trainLabelNew=trainLabel;
% testDataNew=testData(:,newSort(1:i));
% testLabelNew=testLabel;
% model = libsvmtrain(trainLabelNew, trainDataNew, '-c 32 -g 0.01');
% [predict_label, acc,~] = libsvmpredict(testLabelNew, testDataNew, model);
% Acc=cat(1,Acc,acc(1));
% end





