%求取提取特征的时间
% 需要提取的特征MAV、MAV1、MAV2、SSI、RMS、LOG、WL、DASDV、VAR、VORDER

clc;
clear;

% global floderPath dataTrainName FUN featDim
file='H:\特征保存\长期实验\zhj20170509';
floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
hand=1;%设为1，提取所有数据的特征，不分左右手
% featDim=8;%用于提取特征阈值

% 需要提取的特征，没有4个需要阈值的特征
% funName={'feature_MAV','feature_MAV1','feature_MAV2','feature_SSI','feature_RMS',...
%     'feature_LOG','feature_WL','feature_DASDV','feature_VAR','feature_VORDER',...
%     'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
%     'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER',...
%     'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
%     'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER',...
%     'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
%     'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER'};
%% 提取特征
featNum=length(funName);
for NUM=1:featNum
    FUN=funName{NUM};
    for start=1%:hand %2是指左右手都采集数据,如果单手采集的话则改为1。如果只是需要一只手的数据，则是start=1:2,不是把hand=1
        for i=1%((start-1)*repeatNum+1):(hand*repeatNum):num 
            tic;
            timing=[];
            dataTrainName=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%确定训练集数据             
            end
            %提取特征，如果已经提取过了，则直接加载
            trainData=[];
            if exist([file,'\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
                continue;
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
%                         thresh=GA_FeatPara;%GA优化求阈值参数
                        thresh=PSO_FeatPara;%PSO优化求阈值参数
%                         evalin('base' ,['threshSaved.',FUN,'=thresh']);%保存thresh及其对应的特征名称
                        save([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh');%保存阈值
                    else
                        continue;
                    end
                    for n=1:trainLen
                        trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
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
                trainData=cat(2,trainData,trainDataTemp);
                timing_temp=toc;
                timing=cat(1,timing,timing_temp);
                if flag==0%如果是几种阈值优化的特征，则不用保存。别的特征要保存
                    featSaved=trainDataTemp;
                    featSaved=cat(2,featSaved,train_label);
                    save([file,'\特征保存\',FUN,'-',dataTrainName,'.mat'],'featSaved','timing');
                end    
            end                                                       
        end    
    end
end
    