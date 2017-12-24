function [sol,val]=fitness_PNN(sol,options)
% 优化特征参数的适应度函数
% 用识别正确率作为适应度，可以考虑用别的参数作为适应度

global trainData trainLabel
featData=trainData;
featLabel=trainLabel;
bestSpread=sol(1);
%% 分类正确率作为适应度
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
    net=newpnn(train_Data,train_Label,bestSpread);
    predictLabel=sim(net,test_Data);
    predict_label=vec2ind(predictLabel);
    Acc= length(find(predict_label == test_Label))/length(test_Label)*100;
    result=cat(1,result,Acc);

end
val=mean(result);


end

