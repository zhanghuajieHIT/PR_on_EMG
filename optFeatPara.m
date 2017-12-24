%% 用于实现特征阈值参数寻优

clc;
clear;

global floderPath dataTrainName FUN referDataName
% referDataName='b1b2';
floderPath='C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
hand=2;
xlsFileName='C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300\实验记录.xlsx';
experimentTime='zhj20170108';

% 特征参数改进
% funName={'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};
funName={'feature_WAMP'};
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
                FUN=featFusion{NUM,k}.name;
                if exist(['C:\Users\zhj\Desktop\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
                    load(['C:\Users\zhj\Desktop\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat']);
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
%                         thresh=GA_FeatPara;%GA优化求阈值参数
%                         thresh=PSO_FeatPara;%PSO优化求阈值参数
%                         evalin('base' ,['threshSaved.',FUN,'=thresh']);%保存thresh及其对应的特征名称
%                         thresh=Para(train_data(:,:,1)');
                        for n=1:trainLen
                            thresh=Para(train_data(:,:,n)');
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
                        end           
                    else
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)'));
                        end        
                    end
                    trainData=cat(2,trainData,trainDataTemp);
                    if flag==0%如果是几种阈值优化的特征，则不用保存。别的特征要保存
                        featSaved=trainDataTemp;
                        featSaved=cat(2,featSaved,train_label);
                        save(['C:\Users\zhj\Desktop\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat'],'featSaved');
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
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k}.name;
                    if exist(['C:\Users\zhj\Desktop\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                        load(['C:\Users\zhj\Desktop\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat']);
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
%                             thresh=Para(test_data(:,:,1)');
                            for n=1:testLen
                                thresh=Para(test_data(:,:,n)');
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                            end
                        else
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)'));
                            end
                        end
                        testData=cat(2,testData,testDataTemp);
                        if flag==0
                            featSaved=testDataTemp;
                            featSaved=cat(2,featSaved,test_label);
                            save(['C:\Users\zhj\Desktop\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat'],'featSaved');
                        end
                    end                                                   
                end
                testLabel=test_label;
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
% result=readData(experimentTime,xlsFileName);

fprintf('均值计算完成。\n');

