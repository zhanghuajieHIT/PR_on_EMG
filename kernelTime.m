% 计算核函数的时间
clc;
clear;

%***********修改********
%如果是单核，则k_num=[];kernelType=某一种核
%如果是多核，则kernelType=[];k_num=1,或2，或3
kernelType=[];%单核的选择为
k_num=1;%多核的选择为
saveName='';%设置名称
floderPath='H:\特征保存\fsr20170325\无归一化预处理后，overlap为128,len为256';
file='H:\特征保存\fsr20170325';
%**********************
FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
dataTrainName='a1a2a3a4';
timing=zeros(6,1);
for featKindNum=97:102%+6%在多核时，最好一个一个特征计算，不然不知道为什么所有特征的时间是一样的？？？
    trainData=[];
    funName=eval(['FunName.',char(featKindNum)]);    
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
    trainData=real(trainData);
    trainLabel=train_label;
    %简单动作组
    [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
    trainData=mapminmax(trainData',0,5)';%归一化
    testData=trainData;
    

if isempty(kernelType)%多核
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
     tic;
     for i=1:length(testData)
         [k_test,~]=multiKernelFunc(trainData,testData(i,:),kernelTemp,coef,kernelType);%并不在意接收数据
     end
     timing(featKindNum-96)=toc;
elseif isempty(k_num)%单核
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
    tic;
    for i=1:length(testData)
        k_test=kernelFunc(trainData,kernelType,kernelPara,testData(i,:));
    end
    timing(featKindNum-96)=toc;
end
%保存
save(['kernelTime_',saveName,'_',char(featKindNum),'.mat'],'timing');

end
