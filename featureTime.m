%��ȡ��ȡ������ʱ��
% ��Ҫ��ȡ������MAV��MAV1��MAV2��SSI��RMS��LOG��WL��DASDV��VAR��VORDER

clc;
clear;

% global floderPath dataTrainName FUN featDim
file='H:\��������\����ʵ��\zhj20170509';
floderPath=[file,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
hand=1;%��Ϊ1����ȡ�������ݵ�����������������
% featDim=8;%������ȡ������ֵ

% ��Ҫ��ȡ��������û��4����Ҫ��ֵ������
% funName={'feature_MAV','feature_MAV1','feature_MAV2','feature_SSI','feature_RMS',...
%     'feature_LOG','feature_WL','feature_DASDV','feature_VAR','feature_VORDER',...
%     'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
%     'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER',...
%     'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
%     'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER',...
%     'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
%     'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER'};
%% ��ȡ����
featNum=length(funName);
for NUM=1:featNum
    FUN=funName{NUM};
    for start=1%:hand %2��ָ�����ֶ��ɼ�����,������ֲɼ��Ļ����Ϊ1�����ֻ����Ҫһֻ�ֵ����ݣ�����start=1:2,���ǰ�hand=1
        for i=1%((start-1)*repeatNum+1):(hand*repeatNum):num 
            tic;
            timing=[];
            dataTrainName=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%ȷ��ѵ��������             
            end
            %��ȡ����������Ѿ���ȡ���ˣ���ֱ�Ӽ���
            trainData=[];
            if exist([file,'\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                continue;
            else
                [train_data,train_label]=loadData(floderPath,dataTrainName);
                trainLen=size(train_data,3);
                trainDataTemp=[];
                % ��������¼�������������GA�Ż���ֵ
                flag=0;
                if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                        strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                    flag=1;
                    if ~exist([file,'\��������\',FUN,'-',dataTrainName,'-thresh.mat'],'file')
%                         thresh=GA_FeatPara;%GA�Ż�����ֵ����
                        thresh=PSO_FeatPara;%PSO�Ż�����ֵ����
%                         evalin('base' ,['threshSaved.',FUN,'=thresh']);%����thresh�����Ӧ����������
                        save([file,'\��������\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh');%������ֵ
                    else
                        continue;
                    end
                    for n=1:trainLen
                        trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
                    end           
                elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'��
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
                if flag==0%����Ǽ�����ֵ�Ż������������ñ��档�������Ҫ����
                    featSaved=trainDataTemp;
                    featSaved=cat(2,featSaved,train_label);
                    save([file,'\��������\',FUN,'-',dataTrainName,'.mat'],'featSaved','timing');
                end    
            end                                                       
        end    
    end
end
    