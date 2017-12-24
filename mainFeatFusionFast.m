%% ʵ�����������������
% ���ٰ汾���������Ľ��

clc;
clear;

count=100000;
global floderPath dataTrainName FUN featDim
file='H:\��������\zhj20170322';
floderPath=[file,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'];
% floderPath='H:\��������\wcl20170310-1\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
hand=2;
featDim=8;
% xlsFileName='H:\��������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\ʵ���¼.xlsx';
% experimentTime='zhj20170201-1';

% Ч���Ϻõ���������
% funName={'feature_BF_MAV','feature_BF_MAV1','feature_BF_MAV2','feature_BF_SSI','feature_BF_RMS',...
%     'feature_BF_LOG','feature_BF_WL','feature_BF_DASDV','feature_BF_VAR','feature_BF_VORDER',...
%     'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
%     'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER',...
%     'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
%     'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER',...
%     'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
%     'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER',...
%     'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};

% funName={'feature_SSC'};

funName={'feature_DFT_MAV2'};

%% �������
featFusionNum=1;%��ϵ�������Ŀ
featFusion=nchoosek(funName,featFusionNum);%�������
featNum=size(featFusion,1);%������Ϻ�õ���������Ŀ


% ��ȡ����
RESULT=[];
ROW=1;%�����жϣ��޸Ĵ˴������´�δ����ĵط���ʼ
for NUM=1:featNum%�����жϣ��޸Ĵ˴�
    result=[];
%     [~,text]=xlsread(xlsFileName,experimentTime);
%     row=size(text,1);
%     featLoc=['A',num2str(row+1)];%����������xls�ļ��е�λ��
    featName={};
    for i=1:featFusionNum
        featName= cat(2,featName,featFusion{NUM,i}(9:end));
    end
    
    for start=1:hand %2��ָ�����ֶ��ɼ�����,������ֲɼ��Ļ����Ϊ1�����ֻ����Ҫһֻ�ֵ����ݣ�����start=1:2,���ǰ�hand=1
        Acc=[];%���ڱ�������
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%ȷ��ѵ��������             
            end
            dataName=cat(2,dataName,dataTrainName);%����ѵ�����������ݵ�����
            %��ȡ����������Ѿ���ȡ���ˣ���ֱ�Ӽ���
            trainData=[];
            for k=1:featFusionNum
                FUN=featFusion{NUM,k};
%                 FUN=featFusion{NUM,k}.name;
                if exist([file,'\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                    load([file,'\��������\',FUN,'-',dataTrainName,'.mat']);
                    trainData=cat(2,trainData,featSaved(:,1:end-1));
                    train_label=featSaved(:,end);%label����һ����
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
%                             thresh=GA_FeatPara;%GA�Ż�����ֵ����
                            thresh=PSO_FeatPara;%PSO�Ż�����ֵ����
%                             evalin('base' ,['threshSaved.',FUN,'=thresh']);%����thresh�����Ӧ����������
                            save([file,'\��������\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh');%������ֵ
                        else
                            load([file,'\��������\',FUN,'-',dataTrainName,'-thresh.mat']);
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
%                     trainDataTemp=trainDataTemp./sum(trainDataTemp.^2)^0.5;
                    trainData=cat(2,trainData,trainDataTemp);
                    if flag==0%����Ǽ�����ֵ�Ż������������ñ��档�������Ҫ����
                        featSaved=trainDataTemp;
                        featSaved=cat(2,featSaved,train_label);
                        save([file,'\��������\',FUN,'-',dataTrainName,'.mat'],'featSaved');
                    end    
                end                                                  
            end
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%��һ��
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%ȷ�����Լ�����
                end
                % ��ѵ������ͬ����Ҫ����
                if strcmp(dataTestName,dataTrainName)
                    continue;
                end
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k};
%                     FUN=featFusion{NUM,k}.name;
                    if exist([file,'\��������\',FUN,'-',dataTestName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                        load([file,'\��������\',FUN,'-',dataTestName,'.mat']);
                        testData=cat(2,testData,featSaved(:,1:end-1));
                        test_label=featSaved(:,end);%label����һ���� 
                    else
                        [test_data,test_label]=loadData(floderPath,dataTestName);
                        testLen=size(test_data,3);
                        testDataTemp=[];
                        % ��������¼������������Ѿ��õ�����ֵ��ȡ������
                        flag=0;
                        if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                                strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                            flag=1;
%                             thresh=eval(['threshSaved.',FUN]);%��ȡ����Ķ�Ӧ��������ֵ
                            load([file,'\��������\',FUN,'-',dataTrainName,'-thresh.mat']);
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                            end
                        elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'��
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
                            save([file,'\��������\',FUN,'-',dataTestName,'.mat'],'featSaved');
                        end
                    end                                                   
                end
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%��һ��
                
                % �򵥶�����
                [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
                [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
                trainData=mapminmax(trainData',0,5)';%��һ��
                testData=mapminmax(testData',0,5)';%��һ��
                
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                Acc=cat(1,Acc,acc(1));
        
            end
    
        end
        
        result=cat(1,result,Acc);
        %% ���ݱ��浽xls�ļ���
%         [~,text]=xlsread(xlsFileName,experimentTime);
%         row=size(text,1);
%         rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
%         colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
%         resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
%         result=reshape(Acc,3,3)';%��������޸�
%         xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
%         xlswrite(xlsFileName,dataName',experimentTime,colLoc);
%         xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

    end
    
    % ��Ϊ����EXCEL
%     RESULT=cat(1,RESULT,roundn(mean(result),-2));
%     if NUM>count
%         experimentTime='zhj20170201-2';
%     end
%     if (length(RESULT)==100)||(NUM==featNum)
%         if ROW>count % �����жϺ����¸�����ֵʱ����count�����
%             ROW=ROW-count;
%         end
%         xlswrite(xlsFileName,RESULT,experimentTime,['A',num2str(ROW)]);
%         RESULT=[];
%         ROW=NUM+1;
%         if (NUM>count)||(ROW>count)% (ROW>count)����ʡ��
%             ROW=NUM-count+1;
%         end
%     end
%     disp(['NUM=',num2str(NUM)]);
%     fprintf('\n');
end

fprintf('������ɣ�������������ȷ�ʾ�ֵ�����档\n');

%% �����ֵ������
% result=readData(experimentTime,xlsFileName);

fprintf('��ֵ������ɡ�\n');

