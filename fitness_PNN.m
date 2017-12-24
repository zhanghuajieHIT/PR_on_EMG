function [sol,val]=fitness_PNN(sol,options)
% �Ż�������������Ӧ�Ⱥ���
% ��ʶ����ȷ����Ϊ��Ӧ�ȣ����Կ����ñ�Ĳ�����Ϊ��Ӧ��

global trainData trainLabel
featData=trainData;
featLabel=trainLabel;
bestSpread=sol(1);
%% ������ȷ����Ϊ��Ӧ��
% ʹ�ý�����֤�ķ���
K=10;
index=crossvalind('Kfold',featLabel,K);%�õ�������֤������
result=[];%���ڼ�¼K�ε�ʶ����
for i=1:K %K�ۣ���Ҫ��ȡK��ƽ��ֵ��Ϊ���
    testIndex=(index==i);
    trainIndex=(index~=i);
    test_data=featData(testIndex,:);%��������
    test_label=featLabel(testIndex,:);
    train_data=featData(trainIndex,:);%ѵ������
    train_label=featLabel(trainIndex,:);
    %��һ��
    train_data=mapminmax(train_data',0,5)';
    test_data=mapminmax(test_data',0,5)';
    %����
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

