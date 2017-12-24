%% 实现组合特征特征计算
% 快速版本，仅有最后的结果

clc;
clear;

count=100000;
global floderPath dataTrainName FUN featDim
file='H:\特征保存\zhj20170322';
floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
% floderPath='H:\特征保存\wcl20170310-1\无归一化预处理后，overlap为100,len为300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
hand=2;
featDim=8;
% xlsFileName='H:\特征保存\zhj20161219\无归一化预处理后，overlap为100,len为300\实验记录.xlsx';
% experimentTime='zhj20170201-1';

% 效果较好的所有特征
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

%% 特征组合
featFusionNum=1;%组合的特征数目
featFusion=nchoosek(funName,featFusionNum);%排列组合
featNum=size(featFusion,1);%进行组合后得到的特征数目


% 提取特征
RESULT=[];
ROW=1;%出现中断，修改此处，重新从未计算的地方开始
for NUM=1:featNum%出现中断，修改此处
    result=[];
%     [~,text]=xlsread(xlsFileName,experimentTime);
%     row=size(text,1);
%     featLoc=['A',num2str(row+1)];%特征名称在xls文件中的位置
    featName={};
    for i=1:featFusionNum
        featName= cat(2,featName,featFusion{NUM,i}(9:end));
    end
    
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
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
                end
                % 与训练集相同则不需要测试
                if strcmp(dataTestName,dataTrainName)
                    continue;
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
                            load([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
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
                
                % 简单动作组
                [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
                [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
                trainData=mapminmax(trainData',0,5)';%归一化
                testData=mapminmax(testData',0,5)';%归一化
                
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                Acc=cat(1,Acc,acc(1));
        
            end
    
        end
        
        result=cat(1,result,Acc);
        %% 数据保存到xls文件中
%         [~,text]=xlsread(xlsFileName,experimentTime);
%         row=size(text,1);
%         rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
%         colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
%         resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
%         result=reshape(Acc,3,3)';%根据情况修改
%         xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
%         xlswrite(xlsFileName,dataName',experimentTime,colLoc);
%         xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

    end
    
    % 分为两个EXCEL
%     RESULT=cat(1,RESULT,roundn(mean(result),-2));
%     if NUM>count
%         experimentTime='zhj20170201-2';
%     end
%     if (length(RESULT)==100)||(NUM==featNum)
%         if ROW>count % 用于中断后重新给定数值时超过count的情况
%             ROW=ROW-count;
%         end
%         xlswrite(xlsFileName,RESULT,experimentTime,['A',num2str(ROW)]);
%         RESULT=[];
%         ROW=NUM+1;
%         if (NUM>count)||(ROW>count)% (ROW>count)可以省略
%             ROW=NUM-count+1;
%         end
%     end
%     disp(['NUM=',num2str(NUM)]);
%     fprintf('\n');
end

fprintf('分类完成，接下来计算正确率均值并保存。\n');

%% 计算均值并保存
% result=readData(experimentTime,xlsFileName);

fprintf('均值计算完成。\n');

