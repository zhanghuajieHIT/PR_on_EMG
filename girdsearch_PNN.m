function [bestSpread,bestAcc]=girdsearch_PNN(data,label,spreadBound)
% PNN的逐点寻优
% spreadBound=[spreadmin,spreadmax,spreadstep]

featData=data;
featLabel=label;

if nargin==2
   spreadmin=1;
   spreadmax=200;
   spreadstep=1;
else
   spreadmin=spreadBound(1);
   spreadmax=spreadBound(2);
   spreadstep=spreadBound(3);
end

spread=spreadmin:spreadstep:spreadmax;
m=length(spread);
bestSpread=spreadmin;
acc=ones(m,1);
bestAcc=0;
for ii=1:m
    spreadTemp=spread(ii);
    % 使用交叉验证的方法
    K=10;
    index=crossvalind('Kfold',featLabel,K);%得到交叉验证的索引
    result=[];%用于记录K次的识别结果
    for i=1:K %K折，需要求取K次平均值作为结果
        testIndex=(index==i);
        trainIndex=(index~=i);
        test_data=featData(testIndex,:);%测试数据
        test_label=featLabel(testIndex,:);
        train_data=featData(trainIndex,:);%训练数据
        train_label=featLabel(trainIndex,:);
        %归一化
        train_data=mapminmax(train_data',0,5)';
        test_data=mapminmax(test_data',0,5)';
        %分类
        train_Data=train_data';
        train_Label=train_label';
        train_Label=ind2vec(train_Label);
        test_Data=test_data';
        test_Label=test_label';
        net=newpnn(train_Data,train_Label,spreadTemp);
        predictLabel=sim(net,test_Data);
        predict_label=vec2ind(predictLabel);
        Acc= length(find(predict_label == test_Label))/length(test_Label)*100;
        result=cat(1,result,Acc);

    end
    acc(ii)=mean(result);
    if acc(ii)>bestAcc
        bestAcc=acc(ii);
        bestSpread=spreadTemp;
    end
end
%% 画出spread和识别率的对应图形
figure;
plot(spread,acc);
title('不同spread的识别正确率');
xlabel('spread');
ylabel('识别正确率（%）');
end
