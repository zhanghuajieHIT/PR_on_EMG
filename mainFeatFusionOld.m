%% 实现组合特征特征计算

clc;
clear;

global floderPath
file='H:\特征保存\zhj20170322';
floderPath=[file,'\无归一化预处理后，overlap为100,len为300'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
hand=2;
xlsFileName='E:\实验\Delsys数据采集\实验记录\实验记录.xlsx';
experimentTime='zhj20170107';

% funName={'feature_MAV','feature_MAV1','feature_MAV2','feature_SSI',...
%     'feature_VAR','feature_RMS',...
%     'feature_VORDER','feature_LOG','feature_WL','feature_AAC','feature_DASDV',...
%     'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC','feature_MHW','feature_MTW',...
%     'feature_HIST',...
%     'feature_MDF','feature_PKF','feature_MNP','feature_TTP','feature_SMN1','feature_SMN2',...
%     'feature_SMN3','feature_MFMD',...
%     'feature_WCE','feature_WCM','feature_WCSVD','feature_WPCE','feature_WPCM','feature_WPCSVD'};

% 特征参数改进
% funName={'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};

%% 得到组合特征的总维度以及组合的各特征名称
fun=Feat_Dim_Name(funName);

%% 特征组合
featFusionNum=1;%组合的特征数目
featFusion=nchoosek(fun,featFusionNum);%排列组合
featNum=size(featFusion,1);%进行组合后得到的特征数目

% 提取特征
for NUM=1:featNum
    [~,text]=xlsread(xlsFileName,experimentTime);
    row=size(text,1);
    featLoc=['A',num2str(row+1)];%特征名称在xls文件中的位置
    featName={};
    featTotalCol= 0;
    for i=1:featFusionNum
       featName= cat(2,featName,featFusion{NUM,i}.name(9:end));
       featTotalCol= featTotalCol+featFusion{NUM,i}.featCol;
    end
    xlswrite(xlsFileName,featName,experimentTime,featLoc);%保存组合特征的名称
    
    for start=1:hand %2是指左右手都采集数据,如果单手采集的话则改为1
        Acc=[];%用于保存数据
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
                    if exist(['H:\特征保存\zhj20161219\',FUN,'-',dataTrainNameTemp,'.mat'],'file')%是否已经提取过该特征
                        load(['H:\特征保存\zhj20161219\',FUN,'-',dataTrainNameTemp,'.mat']);
                        trainData=cat(2,trainData,featSaved);
                    else
                        trainLen=size(train.DataStructure.rawEMG,3);
                        trainDataTemp=[];
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train.DataStructure.rawEMG(:,:,n)'));
                        end
                        trainData=cat(2,trainData,trainDataTemp);
                        featSaved=trainDataTemp;
                        save(['H:\特征保存\zhj20161219\',FUN,'-',dataTrainNameTemp,'.mat'],'featSaved');
                    end
                                                                   
                end
                trainLabel=train.DataStructure.labelID;
                trainData=mapminmax(trainData',0,5)';%归一化
        
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k}.name;
                    if exist(['H:\特征保存\zhj20161219\',FUN,'-',dataTestNameTemp,'.mat'],'file')%是否已经提取过该特征
                        load(['H:\特征保存\zhj20161219\',FUN,'-',dataTestNameTemp,'.mat']);
                        testData=cat(2,testData,featSaved);
                    else
                        testLen=size(test.DataStructure.rawEMG,3);
                        testDataTemp=[];
                        for n=1:testLen
                            testDataTemp=cat(1,testDataTemp,feval(FUN,test.DataStructure.rawEMG(:,:,n)'));
                        end
                        testData=cat(2,testData,testDataTemp);
                        featSaved=testDataTemp;
                        save(['H:\特征保存\zhj20161219\',FUN,'-',dataTestNameTemp,'.mat'],'featSaved');
                    end
                                                                   
                end
                testLabel=test.DataStructure.labelID;
                testData=mapminmax(testData',0,5)';%归一化
                
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                Acc=cat(1,Acc,acc(1));
                
%             %% pca降维
%                 trainDataPCA=PCA_opt(trainData,0.95);%原数据能量的百分比
%                 testDataPCA=PCA_opt(testData,0.95);
%                % 归一化，效果更差
%                 trainDataPCA=mapminmax(trainDataPCA',0,5)';
%                 testDataPCA=mapminmax(testDataPCA',0,5)';               
%                 model = libsvmtrain(trainLabel, trainDataPCA, '-c 32 -g 0.01');
%                 [predict_label, acc,~] = libsvmpredict(testLabel, testDataPCA, model);
%                 Acc=cat(1,Acc,acc(1));
        
            end
    
        end
        
        %% 数据保存到xls文件中
        [~,text]=xlsread(xlsFileName,experimentTime);
        row=size(text,1);
        rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
        colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
        resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
        result=reshape(Acc,3,3)';
        xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
        xlswrite(xlsFileName,dataName',experimentTime,colLoc);
        xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

    end
    
end

fprintf('分类完成，接下来计算正确率均值并保存。\n');

%% 计算均值并保存
result=readData(experimentTime,xlsFileName);

fprintf('均值计算完成。\n');

