%% 多核SVM和不同核SVM的主函数
% 课题实验2的数据分类
clc;
clear;

file='E:\zhj\zhj20170322';
floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;

FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
% FunName.g={'feature_DFT_MAV2','feature_DFT_DASDV','feature_WT_LOG','feature_WAMP'};
FunName.g={'feature_DFT_MAV2','feature_DFT_WL','feature_MYOP','feature_WAMP',...
'feature_WT_MAV2','feature_WT_VORDER','feature_WPT_VAR','feature_DFT_DASDV','feature_WT_LOG'};

TotalTotalAcc=[];
% for ii=0.01:0.01:1
    
TotalAcc=[];%用于记录所有特征的最后结果
for featKindNum=101:101%+6
    funName=eval(['FunName.',char(featKindNum)]);

%% 把数据分为左手和右手
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

%% 左手数据为训练集，右手数据为测试集
allDataName=[leftDataName;rightDataName];
Acc4=[];%用于保存所有的正确率

for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%确定训练数据
    trainData=[];
    for k=1:length(funName)%加载训练数据
        FUN=cell2mat(funName(k));
        if exist([file,'\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
            load([file,'\特征保存\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label都是一样的
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end
            trainData=cat(2,trainData,trainDataTemp);
        end
    end
    trainLabel=train_label;
    trainData=real(trainData);
    trainData=mapminmax(trainData',0,5)';%归一化
    
                %% PCA降维
%             no_dims = round(intrinsic_dim(trainData, 'EigValue'));
%             no_dims=100;
%             trainDataOri=[trainLabel,trainData];
%             [mappedX, mapping] = compute_mapping(trainDataOri, 'LDA',no_dims);
%             trainData=mappedX;
    
    %% 确定测试数据并加载
    if i<=length(leftDataName)%确定测试数据
        startIndex=length(leftDataName)+1;
        endIndex=length(allDataName);
    else
        startIndex=1;
        endIndex=length(leftDataName);
    end
    for j=startIndex:endIndex
        dataTestName=cell2mat(allDataName(j));
        testData=[];
        for k=1:length(funName)%加载测试数据
            FUN=cell2mat(funName(k));
            if exist([file,'\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                load([file,'\特征保存\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label都是一样的
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load([file,'\特征保存\',FUN,'-',dataTestName,'-thresh.mat']);
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=cat(2,testData,testDataTemp);
            end
        end
        testLabel=test_label;
        testData=real(testData);
        testData=mapminmax(testData',0,5)';%归一化
        
                        %% PCA降维
% %                 no_dims = round(intrinsic_dim(testData, 'EigValue'));
%                 testDataOri=[testLabel,testData];
%                 [mappedX, mapping] = compute_mapping(testData, 'LDA', no_dims);
%                 testData=mappedX;
        
        %% 分类
        %% 单个不同核，需要输入核函数的参数
        kernelType='rbf';%可以改变核函数
        if strcmp('rbf',kernelType)
            kernelPara=0.01;%设置核函数的参数
        elseif strcmp('lin',kernelType)
            kernelPara=[];
        elseif strcmp('poly',kernelType)
            kernelPara=[0.01 0 3];
        elseif strcmp('sig',kernelType)
            kernelPara=[0.01 0];
        elseif strcmp('rq',kernelType)
            kernelPara=[110];
        elseif strcmp('gen',kernelType)
            kernelPara=[];
        elseif strcmp('cauchy',kernelType)
            kernelPara=[3];
        elseif strcmp('logk',kernelType)
            kernelPara=[];
        elseif strcmp('power',kernelType)
            kernelPara=[];
        elseif strcmp('expk',kernelType)
            kernelPara=[12.5];
        elseif strcmp('inmk',kernelType)
            kernelPara=[4.5];
        elseif strcmp('multiq',kernelType)%效果奇差无比
            kernelPara=[3];
        elseif strcmp('lap',kernelType)
            kernelPara=[319];
        elseif strcmp('spher',kernelType)
            kernelPara=[165];
        end  
        k_train=kernelFunc(trainData,kernelType,kernelPara);
        k_test=kernelFunc(trainData,kernelType,kernelPara,testData);
         
         %% 多核
        
%         kernelType=cell(1,4);
%         kernelType{1,1}='rbf';
%         kernelType{1,2}='expk';
%         kernelType{1,3}='rq';
%         kernelType{1,4}='inmk';
%         coef=[1,1,1,1];
%         [k_train,kernelTemp]=multiKernelFunc(trainData,[],[],coef,kernelType);
%         [k_test,~]=multiKernelFunc(trainData,testData,kernelTemp,coef,kernelType);
        
        %% 分类
         
        Ktrain=[(1:size(trainData,1))',k_train];
        model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
        Ktest=[(1:size(testData,1))',k_test];
        [predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);
        accuracy=acc(1);
        %% 保存所有的正确率
        Acc4=cat(1,Acc4,accuracy);

    end
end

AverAcc4=mean(Acc4);


TotalAcc=cat(1,TotalAcc,AverAcc4);

end

% TotalTotalAcc=cat(2,TotalTotalAcc,TotalAcc);
% end
