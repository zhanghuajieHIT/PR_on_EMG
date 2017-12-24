%% 用于实现特征阈值参数寻优

clc;
clear;

global floderPath dataTrainName dataTestName FUN

file='C:\Users\dlr\Desktop\zhj\zhj20170322';
floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];


% 特征参数改进
% funName={'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};
funName={'feature_MYOP'};
FUN=cell2mat(funName);
dataTrainName='i1i2i3i4';
dataTestName='k1k2k3k4';
thresh=PSO_FeatPara_EX;%PSO优化求阈值参数

fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;

%% 得到组合特征的总维度以及组合的各特征名称
fun=Feat_Dim_Name(funName);

%% 特征组合
featFusionNum=1;%组合的特征数目
featFusion=nchoosek(fun,featFusionNum);%排列组合
featNum=size(featFusion,1);%进行组合后得到的特征数目

% 提取特征
Acc=[];%用于保存数据
[train_data,train_label]=loadData(floderPath,dataTrainName);
trainLen=size(train_data,3);
trainDataTemp=[];

% load([file,'\',FUN,'-',dataTrainName,'-thresh.mat']);

for n=1:trainLen
    trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
end           
trainData=trainDataTemp;
trainLabel=train_label;
trainData=mapminmax(trainData',0,5)';%归一化

start=1;%1表示左手，2表示右手
hand=2;
for j=((start-1)*repeatNum+1):(hand*repeatNum):num
    dataTestName=[];
    for m=0:repeatNum-1
        dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
    end   
    [test_data,test_label]=loadData(floderPath,dataTestName);
    testLen=size(test_data,3);
    testDataTemp=[];
    % 用已经得到的阈值提取特征。
    for n=1:testLen
      testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
    end
    testData=testDataTemp;
    testLabel=test_label;
    testData=mapminmax(testData',0,5)';%归一化
    model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
    [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
    Acc=cat(1,Acc,acc(1));
end
aa=sum(Acc)-max(Acc)    
save([file,'\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh')
