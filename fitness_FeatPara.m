function [sol,val]=fitness_FeatPara(sol,options)
% 优化特征参数的适应度函数
% 用识别正确率作为适应度，可以考虑用别的参数作为适应度

global floderPath FUN dataTrainName featDim referDataName floderPath_referData
% floderPath='C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300';
% dataTrainName='a1a2';
% FUN='feature_ZC';

% dataName_test='c1c2';
[data,label]=loadData(floderPath,dataTrainName);
% [referData,referLabel]=loadData(floderPath,referDataName);


featLen=size(data,3);
featData=zeros(featLen,8);    %注意特征的列数为8，不同的特征可能不一样
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
    
    featData=cat(1,featData,referFeat);%将两组数据组合在一起
    featLabel=cat(1,featLabel,referLabel);
end

featData=mapminmax(featData',0,5)';%归一化

%% 分类正确率作为适应度
%-----------%自带的交叉验证
trainData=featData;
trainLabel=featLabel;
trainData=mapminmax(trainData',0,5)';
acc = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01 -v 10');
val=acc;
%-------------%

% 使用交叉验证的方法
% k=10;%5-flod
% 
%% matlab自带函数交叉验证分组
% index=crossvalind('Kfold',featLabel,k);%得到交叉验证的索引
% result=[];
% for i=1:k %K折，需要求取K次平均值作为结果
%     testIndex=(index==i);
%     trainIndex=(index~=i);
%     test_data=featData(testIndex,:);%测试数据
%     test_label=featLabel(testIndex,:);
%     train_data=featData(trainIndex,:);%训练数据
%     train_label=featLabel(trainIndex,:);
%     %归一化
%     trainData=mapminmax(train_data',0,5)';
%     trainLabel=train_label;
%     testData=mapminmax(test_data',0,5)';
%     testLabel=test_label;
%     %分类
%     model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%可能需要用交叉验证调整
%     [~, acc,~] = libsvmpredict(testLabel, testData, model);
%     result=cat(1,result,acc(1));
%     result=cat(1,result,Acc);
% 
% end
% val=mean(result);
%% 自己写的代码交叉验证分组
% totalNum=length(featData);
% num=fix(totalNum/k);
% index=randperm(totalNum);
% emgData=cell(1,k);
% emgLabel=cell(1,k);
% for i=1:k%数据随机分成k组
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
%     model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%可能需要用交叉验证调整
%     [~, acc,~] = libsvmpredict(testLabel, testData, model);
%     result=cat(1,result,acc(1));
% 
% end

% val=mean(result);

% 不用交叉验证
% testData=featData(1:(length(featLabel)/2),:);
% testLabel=featLabel(1:(length(featLabel)/2));
% testData=mapminmax(testData',0,5)';
% trainData=featData((length(featLabel)/2)+1:end,:);
% trainLabel=featLabel((length(featLabel)/2+1:end));
% trainData=mapminmax(trainData',0,5)';
% model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%可能需要用交叉验证调整
% [~, acc,~] = libsvmpredict(testLabel, testData, model);
% val=acc(1);

%% 马氏距离作为适应度
% [~,MDTotal]=MDistance(featData,featLabel);
% [~,ratioTotal]=FisherRatio(featData,featLabel);
% val=ratioTotal;


end

