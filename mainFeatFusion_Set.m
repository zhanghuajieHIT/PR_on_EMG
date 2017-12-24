%% 实现组合特征特征计算

clc;
clear;
warning off;
global floderPath dataTrainName FUN referDataName floderPath_referData

file1='H:\特征保存\fsr20170325';
file2='H:\特征保存\zhj20170322';
file3='H:\特征保存\scy20170323';
% file4='H:\特征保存\wrj20170328';
file4='H:\特征保存\zyh20170328';
file5='H:\特征保存\xsp20170327';
file6='H:\特征保存\zgj20170324';
% file7='H:\特征保存\zyh20170328';
fileSet={file1,file2,file3,file4,file5,file6};
for iii=1:length(fileSet)
    iii
    file=cell2mat(fileSet(iii));
% file='C:\Users\Robinson\Desktop\zhj\zgj20170324';
floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
hand=2;
xlsFileNameTemp=file(end-11:end);
xlsFileName=[file,xlsFileNameTemp,'.xlsx'];
% xlsFileName=[file,'\zgj20170324.xlsx'];
experimentTime='阈值优化';%不包括特征阈值 原始单一特征
% funName={'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
%     'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER'...
%     'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
%     'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER'...
%     'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
%     'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER'};
% funName={'feature_BF_MAV','feature_BF_MAV1','feature_BF_MAV2','feature_BF_SSI','feature_BF_RMS',...
%     'feature_BF_LOG','feature_BF_WL','feature_BF_DASDV','feature_BF_VAR','feature_BF_VORDER',...
%     'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
%     'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER',...
%     'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
%     'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER',...
%     'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
%     'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER',...
%     'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};

% 原始单一特征,不包括四个特征阈值特征
% funName={'feature_MAV','feature_MAV1','feature_MAV2','feature_SSI','feature_RMS',...
%     'feature_LOG','feature_WL','feature_DASDV','feature_VAR','feature_VORDER','feature_MDF',...
%     'feature_SM3','feature_MDA','feature_WTM','feature_WTSVD','feature_WPTM','feature_WPTSVD'};
% 时域特征改进
% funName={'feature_BF_MAV','feature_BF_MAV1','feature_BF_MAV2','feature_BF_SSI','feature_BF_RMS',...
%     'feature_BF_LOG','feature_BF_WL','feature_BF_DASDV','feature_BF_VAR','feature_BF_VORDER'};
% 频域提取特征
% funName={'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
%     'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER'};
% 特征参数改进
funName={'feature_ZC','feature_WAMP','feature_SSC'};
% funName={'feature_MYOP'};
% 基于WT提取特征
% funName={'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
%     'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER'};
% 基于WPT提取特征
% funName={'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
%     'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER'};
%% 得到组合特征的总维度以及组合的各特征名称
% fun=Feat_Dim_Name(funName);

%% 特征组合
featFusionNum=1;%组合的特征数目
featFusion=nchoosek(funName,featFusionNum);%排列组合
featNum=size(featFusion,1);%进行组合后得到的特征数目

% 提取特征
for NUM=1:featNum
    % 分为两个EXCEL
%     if NUM>100000
%         experimentTime='实验一单一特征-2';
%     end
    
    [~,text]=xlsread(xlsFileName,experimentTime);
    row=size(text,1);
    featLoc=['A',num2str(row+1)];%特征名称在xls文件中的位置
    featName={};
%     featTotalCol= 0;
    for i=1:featFusionNum
        featName= cat(2,featName,featFusion{NUM,i}(9:end));
%        featName= cat(2,featName,featFusion{NUM,i}.name(9:end));
%        featTotalCol= featTotalCol+featFusion{NUM,i}.featCol;
    end
    xlswrite(xlsFileName,featName,experimentTime,featLoc);%保存组合特征的名称
    
    for start=1:hand %2是指左右手都采集数据,如果单手采集的话则改为1。如果只是需要一只手的数据，则是start=1:2,不是把hand=1
        Acc=[];%用于保存数据
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%确定训练集数据             
            end
            dataName=cat(2,dataName,dataTrainName);%保存训练集所有数据的名称
            %提取特征，如果已经提取过了，则直接加载
            trainData=[];
            for k=1:featFusionNum
                FUN=featFusion{NUM,k};
%                 FUN=featFusion{NUM,k}.name;
                if exist([file,'\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
                    load([file,'\特征保存\',FUN,'-',dataTrainName,'.mat']);
                    trainData=cat(2,trainData,featSaved(:,1:end-1));
                    train_label=featSaved(:,end);%label都是一样的
                else
                    [train_data,train_label]=loadData(floderPath,dataTrainName);
                    trainLen=size(train_data,3);
                    trainDataTemp=[];
                    % 如果是以下几种特征，则用GA优化阈值
                    flag=0;
                    if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                            strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                        flag=1;
                        if ~exist([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat'],'file')
%                             thresh=GA_FeatPara;%GA优化求阈值参数
                            thresh=PSO_FeatPara;%PSO优化求阈值参数
%                             evalin('base' ,['threshSaved.',FUN,'=thresh']);%保存thresh及其对应的特征名称
                            save([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh');%保存阈值
                        else
                            load([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
                        end
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
                            %无阈值优化
%                             trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)'));
                        end           
                    elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'等
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_DFT(train_data(:,:,n)',FUN));
                        end
                    elseif strfind(FUN,'_WT')>0
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_WT(train_data(:,:,n)',FUN));
                        end
                    elseif strfind(FUN,'_WPT')>0
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_WPT(train_data(:,:,n)',FUN));
                        end
                    elseif strfind(FUN,'_BF')>0
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_BFeat(train_data(:,:,n)',FUN));
                        end
                    else
                        for n=1:trainLen 
                        trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)'));
                        end
                    end
%                     trainDataTemp=trainDataTemp./sum(trainDataTemp.^2)^0.5;
                    trainData=cat(2,trainData,trainDataTemp);
                    if flag==0%如果是几种阈值优化的特征，则不用保存。别的特征要保存
                        featSaved=trainDataTemp;
                        featSaved=cat(2,featSaved,train_label);
                        save([file,'\特征保存\',FUN,'-',dataTrainName,'.mat'],'featSaved');
                    end    
                end                                                  
            end
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%归一化
            trainData=real(trainData);
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
                end   
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k};
%                     FUN=featFusion{NUM,k}.name;
                    if exist([file,'\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                        load([file,'\特征保存\',FUN,'-',dataTestName,'.mat']);
                        testData=cat(2,testData,featSaved(:,1:end-1));
                        test_label=featSaved(:,end);%label都是一样的 
                    else
                        [test_data,test_label]=loadData(floderPath,dataTestName);
                        testLen=size(test_data,3);
                        testDataTemp=[];
                        % 如果是以下几种特征，用已经得到的阈值提取特征。
                        flag=0;
                        if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                                strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                            flag=1;
%                             thresh=eval(['threshSaved.',FUN]);%提取保存的对应特征的阈值
                            load([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);%就应该是dataTrainName
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                                %无阈值优化
%                                 testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)'));
                            end
                        elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'等
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_DFT(test_data(:,:,n)',FUN));
                            end
                        elseif strfind(FUN,'_WT')>0
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_WT(test_data(:,:,n)',FUN));
                            end
                        elseif strfind(FUN,'_WPT')>0
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_WPT(test_data(:,:,n)',FUN));
                            end
                        elseif strfind(FUN,'_BF')>0
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_BFeat(test_data(:,:,n)',FUN));
                            end
                        else
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)'));
                            end
                        end
%                         testDataTemp=testDataTemp./sum(testDataTemp.^2)^0.5;
                        testData=cat(2,testData,testDataTemp);
                        if flag==0
                            featSaved=testDataTemp;
                            featSaved=cat(2,featSaved,test_label);
                            save([file,'\特征保存\',FUN,'-',dataTestName,'.mat'],'featSaved');
                        end
                    end                                                   
                end
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%归一化
                testData=real(testData);
                %% 简单动作组
% [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
% [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
% trainData=mapminmax(trainData',0,5)';%归一化
% testData=mapminmax(testData',0,5)';%归一化
                
%SVM
%                 model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
%                 [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
%LDA
% model=fitcdiscr(trainData,trainLabel);
% predict_label=predict(model,testData);
% acc=length(find(predict_label==testLabel))/length(testLabel);

model=lda_train(trainData,trainLabel);
[predict_label,acc]=lda_test(model,testData,testLabel);

                Acc=cat(1,Acc,acc(1));
            end
    
        end
        
        %% 数据保存到xls文件中
        [~,text]=xlsread(xlsFileName,experimentTime);
        row=size(text,1);
        rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
        colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
        resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
        result=reshape(Acc,6,6)';%根据情况修改
        xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
        xlswrite(xlsFileName,dataName',experimentTime,colLoc);
        xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

    end
    
    disp(['NUM=',num2str(NUM)]);
    fprintf('\n');
end

end

fprintf('分类完成，接下来计算正确率均值并保存。\n');

%% 计算均值并保存


fprintf('均值计算完成。\n');
