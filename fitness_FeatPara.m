function [sol,val]=fitness_FeatPara(sol,options)
% �Ż�������������Ӧ�Ⱥ���
% ��ʶ����ȷ����Ϊ��Ӧ�ȣ����Կ����ñ�Ĳ�����Ϊ��Ӧ��

global floderPath FUN dataTrainName featDim referDataName floderPath_referData
% floderPath='C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
% dataTrainName='a1a2';
% FUN='feature_ZC';

% dataName_test='c1c2';
[data,label]=loadData(floderPath,dataTrainName);
% [referData,referLabel]=loadData(floderPath,referDataName);


featLen=size(data,3);
featData=zeros(featLen,8);    %ע������������Ϊ8����ͬ���������ܲ�һ��
thresh=sol(1:featDim);
% testLen=size(testDataTemp,3);
% testData=zeros(testLen,8);

for i=1:featLen
    featData(i,:)=feval(FUN,data(:,:,i)',thresh);
end
featLabel=label;

if exist(referDataName,'var')
    [referData,referLabel]=loadData(floderPath_referData,referDataName);
    for i=1:length(referLabel)
        referFeat=feval(FUN,referData(:,:,i)',thresh);
    end
    
    featData=cat(1,featData,referFeat);%���������������һ��
    featLabel=cat(1,featLabel,referLabel);
end

featData=mapminmax(featData',0,5)';%��һ��

%% ������ȷ����Ϊ��Ӧ��
%-----------%�Դ��Ľ�����֤
trainData=featData;
trainLabel=featLabel;
trainData=mapminmax(trainData',0,5)';
acc = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01 -v 10');
val=acc;
%-------------%

% ʹ�ý�����֤�ķ���
% k=10;%5-flod
% 
%% matlab�Դ�����������֤����
% index=crossvalind('Kfold',featLabel,k);%�õ�������֤������
% result=[];
% for i=1:k %K�ۣ���Ҫ��ȡK��ƽ��ֵ��Ϊ���
%     testIndex=(index==i);
%     trainIndex=(index~=i);
%     test_data=featData(testIndex,:);%��������
%     test_label=featLabel(testIndex,:);
%     train_data=featData(trainIndex,:);%ѵ������
%     train_label=featLabel(trainIndex,:);
%     %��һ��
%     trainData=mapminmax(train_data',0,5)';
%     trainLabel=train_label;
%     testData=mapminmax(test_data',0,5)';
%     testLabel=test_label;
%     %����
%     model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%������Ҫ�ý�����֤����
%     [~, acc,~] = libsvmpredict(testLabel, testData, model);
%     result=cat(1,result,acc(1));
%     result=cat(1,result,Acc);
% 
% end
% val=mean(result);
%% �Լ�д�Ĵ��뽻����֤����
% totalNum=length(featData);
% num=fix(totalNum/k);
% index=randperm(totalNum);
% emgData=cell(1,k);
% emgLabel=cell(1,k);
% for i=1:k%��������ֳ�k��
%     emgData{i}=featData(index(1+(i-1)*num:num*i),:);
%     emgLabel{i}=featLabel(index(1+(i-1)*num:num*i),:);
% end
% numIndex=1:k;
% result=[];
% for i=1:k
%     testData=emgData{i};
%     testLabel=emgLabel{i};
%     temp=numIndex;
%     temp(i)=[];
%     trainData=[];
%     trainLabel=[];
%     for j=1:k-1
%         trainData=cat(1,trainData,emgData{temp(j)});
%         trainLabel=cat(1,trainLabel,emgLabel{temp(j)});
%     end
%     trainData=mapminmax(trainData',0,5)';
%     testData=mapminmax(testData',0,5)';
%     model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%������Ҫ�ý�����֤����
%     [~, acc,~] = libsvmpredict(testLabel, testData, model);
%     result=cat(1,result,acc(1));
% 
% end

% val=mean(result);

% ���ý�����֤
% testData=featData(1:(length(featLabel)/2),:);
% testLabel=featLabel(1:(length(featLabel)/2));
% testData=mapminmax(testData',0,5)';
% trainData=featData((length(featLabel)/2)+1:end,:);
% trainLabel=featLabel((length(featLabel)/2+1:end));
% trainData=mapminmax(trainData',0,5)';
% model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%������Ҫ�ý�����֤����
% [~, acc,~] = libsvmpredict(testLabel, testData, model);
% val=acc(1);

%% ���Ͼ�����Ϊ��Ӧ��
% [~,MDTotal]=MDistance(featData,featLabel);
% [~,ratioTotal]=FisherRatio(featData,featLabel);
% val=ratioTotal;


end

