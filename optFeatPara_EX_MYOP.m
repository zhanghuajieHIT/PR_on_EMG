%% ����ʵ��������ֵ����Ѱ��

clc;
clear;

global floderPath dataTrainName dataTestName FUN

file='C:\Users\dlr\Desktop\zhj\zhj20170322';
floderPath=[file,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'];


% ���������Ľ�
% funName={'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};
funName={'feature_MYOP'};
FUN=cell2mat(funName);
dataTrainName='i1i2i3i4';
dataTestName='k1k2k3k4';
thresh=PSO_FeatPara_EX;%PSO�Ż�����ֵ����

fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;

%% �õ������������ά���Լ���ϵĸ���������
fun=Feat_Dim_Name(funName);

%% �������
featFusionNum=1;%��ϵ�������Ŀ
featFusion=nchoosek(fun,featFusionNum);%�������
featNum=size(featFusion,1);%������Ϻ�õ���������Ŀ

% ��ȡ����
Acc=[];%���ڱ�������
[train_data,train_label]=loadData(floderPath,dataTrainName);
trainLen=size(train_data,3);
trainDataTemp=[];

% load([file,'\',FUN,'-',dataTrainName,'-thresh.mat']);

for n=1:trainLen
    trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
end           
trainData=trainDataTemp;
trainLabel=train_label;
trainData=mapminmax(trainData',0,5)';%��һ��

start=1;%1��ʾ���֣�2��ʾ����
hand=2;
for j=((start-1)*repeatNum+1):(hand*repeatNum):num
    dataTestName=[];
    for m=0:repeatNum-1
        dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%ȷ�����Լ�����
    end   
    [test_data,test_label]=loadData(floderPath,dataTestName);
    testLen=size(test_data,3);
    testDataTemp=[];
    % ���Ѿ��õ�����ֵ��ȡ������
    for n=1:testLen
      testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
    end
    testData=testDataTemp;
    testLabel=test_label;
    testData=mapminmax(testData',0,5)';%��һ��
    model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
    [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
    Acc=cat(1,Acc,acc(1));
end
aa=sum(Acc)-max(Acc)    
save([file,'\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh')
