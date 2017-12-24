function Acc=adaboost(trainData,trainLabel,testData,testLabel)
%% adaboost
% �����Ѿ���һ����
%% ��������
index=unique(trainLabel);
indexNum=length(index);% indexNum=14������������
trainDataTemp=[];
trainLabelTemp=[];
for i=1:indexNum
    [row,~]=find(trainLabel==index(i));
    trainDataTemp=cat(1,trainDataTemp,trainData(row,:));
    trainLabelTemp=cat(1,trainLabelTemp,trainLabel(row));
end
trainData=trainDataTemp;
trainLabel=trainLabelTemp;

%% adaboost�Ĺ�����ѵ��
num = 0;
iter = 10;%�涨���������ĸ���
for i = 1:indexNum-1 %14��
    for j = i+1:indexNum 
        num = num + 1;
        %���¹���
        index1 = find(trainLabel == i);
        index2 = find(trainLabel == j);
        label_temp = zeros((length(index1)+length(index2)),1);
        %svm��Ҫ�������ǩ����Ϊ1��-1
        label_temp(1:length(index1)) = 1;%1��Ӧԭ������i
        label_temp(length(index1)+1:length(index1)+length(index2)) = -1;%-1��Ӧԭ������j
        train_temp = [trainData(index1,:);trainData(index2,:)];
        % ѵ��ģ��
        Model{num} = adaboostSVM_train(train_temp,label_temp,iter,[i,j]);%����SVM��adaboost
%         Model{num} = adaboostNB_train(train_temp,label_temp,iter,[i,j]);% �������ر�Ҷ˹
%         Model{num} = adaboostBP_train(train_temp,label_temp,iter,[i,j]);%����BP��adaboost
    end
end
% ��ģ����Ԥ����Լ��ķ���
predictLabel = zeros(length(testData),1);
for ii = 1:length(testData)
    data_test = testData(ii,:);
    label_test=testLabel(ii);
    num = 0;
    voteLabel=zeros(indexNum,1);
    for i = 1:indexNum-1
        for j = i+1:indexNum
            num = num + 1;
            predictLabelTemp = adaboostSVM_predict(data_test,label_test,Model{num});%����SVM��adaboost
%             predictLabelTemp = adaboostNB_predict(data_test,label_test,Model{num});% �������ر�Ҷ˹
%             predictLabelTemp = adaboostBP_predict(data_test,label_test,Model{num});%����BP��adaboost
            voteLabel(predictLabelTemp)=voteLabel(predictLabelTemp)+1;
        end
    end
    [~,predictLabel(ii)] = max(voteLabel);
end

Acc = length(find(predictLabel==testLabel))/length(testLabel);
