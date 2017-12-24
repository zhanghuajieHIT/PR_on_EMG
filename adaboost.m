function Acc=adaboost(trainData,trainLabel,testData,testLabel)
%% adaboost
% 数据已经归一化了
%% 数据排序
index=unique(trainLabel);
indexNum=length(index);% indexNum=14，动作种类数
trainDataTemp=[];
trainLabelTemp=[];
for i=1:indexNum
    [row,~]=find(trainLabel==index(i));
    trainDataTemp=cat(1,trainDataTemp,trainData(row,:));
    trainLabelTemp=cat(1,trainLabelTemp,trainLabel(row));
end
trainData=trainDataTemp;
trainLabel=trainLabelTemp;

%% adaboost的构建与训练
num = 0;
iter = 10;%规定弱分类器的个数
for i = 1:indexNum-1 %14类
    for j = i+1:indexNum 
        num = num + 1;
        %重新归类
        index1 = find(trainLabel == i);
        index2 = find(trainLabel == j);
        label_temp = zeros((length(index1)+length(index2)),1);
        %svm需要将分类标签设置为1与-1
        label_temp(1:length(index1)) = 1;%1对应原来是类i
        label_temp(length(index1)+1:length(index1)+length(index2)) = -1;%-1对应原来的类j
        train_temp = [trainData(index1,:);trainData(index2,:)];
        % 训练模型
        Model{num} = adaboostSVM_train(train_temp,label_temp,iter,[i,j]);%基于SVM的adaboost
%         Model{num} = adaboostNB_train(train_temp,label_temp,iter,[i,j]);% 基于朴素贝叶斯
%         Model{num} = adaboostBP_train(train_temp,label_temp,iter,[i,j]);%基于BP的adaboost
    end
end
% 用模型来预测测试集的分类
predictLabel = zeros(length(testData),1);
for ii = 1:length(testData)
    data_test = testData(ii,:);
    label_test=testLabel(ii);
    num = 0;
    voteLabel=zeros(indexNum,1);
    for i = 1:indexNum-1
        for j = i+1:indexNum
            num = num + 1;
            predictLabelTemp = adaboostSVM_predict(data_test,label_test,Model{num});%基于SVM的adaboost
%             predictLabelTemp = adaboostNB_predict(data_test,label_test,Model{num});% 基于朴素贝叶斯
%             predictLabelTemp = adaboostBP_predict(data_test,label_test,Model{num});%基于BP的adaboost
            voteLabel(predictLabelTemp)=voteLabel(predictLabelTemp)+1;
        end
    end
    [~,predictLabel(ii)] = max(voteLabel);
end

Acc = length(find(predictLabel==testLabel))/length(testLabel);
