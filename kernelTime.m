% ����˺�����ʱ��
clc;
clear;

%***********�޸�********
%����ǵ��ˣ���k_num=[];kernelType=ĳһ�ֺ�
%����Ƕ�ˣ���kernelType=[];k_num=1,��2����3
kernelType=[];%���˵�ѡ��Ϊ
k_num=1;%��˵�ѡ��Ϊ
saveName='';%��������
floderPath='H:\��������\fsr20170325\�޹�һ��Ԥ�����overlapΪ128,lenΪ256';
file='H:\��������\fsr20170325';
%**********************
FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
dataTrainName='a1a2a3a4';
timing=zeros(6,1);
for featKindNum=97:102%+6%�ڶ��ʱ�����һ��һ���������㣬��Ȼ��֪��Ϊʲô����������ʱ����һ���ģ�����
    trainData=[];
    funName=eval(['FunName.',char(featKindNum)]);    
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
    trainData=real(trainData);
    trainLabel=train_label;
    %�򵥶�����
    [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
    trainData=mapminmax(trainData',0,5)';%��һ��
    testData=trainData;
    

if isempty(kernelType)%���
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
         [k_test,~]=multiKernelFunc(trainData,testData(i,:),kernelTemp,coef,kernelType);%���������������
     end
     timing(featKindNum-96)=toc;
elseif isempty(k_num)%����
    if strcmp('rbf',kernelType)
        kernelPara=0.01;%���ú˺����Ĳ���
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
    elseif strcmp('multiq',kernelType)%Ч������ޱ�
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
%����
save(['kernelTime_',saveName,'_',char(featKindNum),'.mat'],'timing');

end
