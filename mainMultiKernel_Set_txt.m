%% ���SVM�Ͳ�ͬ��SVM��������
% ����ʵ��2�����ݷ���
clc;
clear;

file1='C:\Users\dlr\Desktop\zhj\zhj20170322';
file2='C:\Users\dlr\Desktop\zhj\fsr20170325';
file3='C:\Users\dlr\Desktop\zhj\scy20170323';
file4='C:\Users\dlr\Desktop\zhj\wrj20170328';
file5='C:\Users\dlr\Desktop\zhj\xsp20170327';
file6='C:\Users\dlr\Desktop\zhj\zgj20170324';
file7='C:\Users\dlr\Desktop\zhj\zyh20170328';
fileSet={file1,file2,file3,file4,file5,file6,file7};
for iii=1:length(fileSet)
    iii
    file=cell2mat(fileSet(iii));
    
floderPath=[file,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
% xlsFileName=[file,file(end-11:end),'.xlsx'];
% experimentTime='���';%��˻��ߵ���

FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
% FunName.g={'feature_DFT_MAV2','feature_DFT_DASDV','feature_WT_LOG','feature_WAMP'};
% FunName.g={'feature_DFT_MAV2','feature_DFT_WL','feature_MYOP','feature_WAMP',...
% 'feature_WT_MAV2','feature_WT_VORDER','feature_WPT_VAR','feature_DFT_DASDV','feature_WT_LOG'};

for featKindNum=97:102%+6
    funName=eval(['FunName.',char(featKindNum)]);
    fileID_feat=fopen([file,file(end-11:end),'_�������Ƚ�.txt'],'a+');
    fprintf(fileID_feat,'%12s\n',['feature ',char(featKindNum)]);
    fclose(fileID_feat);
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

for k_num=1:3   %��3�ֶ��
    Acc_Temp=[];
for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%ȷ��ѵ������
    trainData=[];
    for k=1:length(funName)%����ѵ������
        FUN=cell2mat(funName(k));
        if exist([file,'\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
            load([file,'\��������\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label����һ����
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load([file,'\��������\',FUN,'-',dataTrainName,'-thresh.mat']);
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
            if exist([file,'\��������\',FUN,'-',dataTestName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                load([file,'\��������\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label����һ����
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load([file,'\��������\',FUN,'-',dataTestName,'-thresh.mat']);
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
         %% ���
         if k_num==1
            kernelType=cell(1,3);
            kernelType{1,1}='rbf';
            kernelType{1,2}='rq';
            kernelType{1,3}='expk';
         elseif k_num==2
             kernelType={'rbfExtend'};
         elseif k_num==3
             kernelType=cell(1,4);
             kernelType{1,1}='rbf';
             kernelType{1,2}='rbf2';
             kernelType{1,3}='rbf3';
             kernelType{1,4}='rbf4';
         end
        coef=ones(1,length(kernelType));
        [k_train,kernelTemp]=multiKernelFunc(trainData,[],[],coef,kernelType);
        [k_test,~]=multiKernelFunc(trainData,testData,kernelTemp,coef,kernelType);
%         
%         %% ����
%          
        Ktrain=[(1:size(trainData,1))',k_train];
        model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
        Ktest=[(1:size(testData,1))',k_test];
        [predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);
        accuracy=acc(1);

        %% �������е���ȷ��
        Acc_Temp=cat(1,Acc_Temp,accuracy);%��Ӧÿ��������72������
    end

end
        %% ���ݱ��浽xls�ļ���
        if k_num==1
            dataName1={'rbf+rq+expk'};%
        elseif k_num==2
            dataName1={'rbfExtend'};
        elseif k_num==3
            dataName1={'rbfMultiscale'};
        end
       
                %% ���ݱ�����txt��
            result=reshape(Acc_Temp',6,12);%��������޸ģ������ʽΪ12*6
            fileID_classify = fopen([file,file(end-11:end),'_�������Ƚ�.txt'],'a+');
            fprintf(fileID_classify,'%12s\n',cell2mat(dataName1));
            fprintf(fileID_classify,'%.2f %.2f %.2f %.2f %.2f %.2f\n',result);
            fclose(fileID_classify);
end

end

end
