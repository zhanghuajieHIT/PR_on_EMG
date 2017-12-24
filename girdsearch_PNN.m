function [bestSpread,bestAcc]=girdsearch_PNN(data,label,spreadBound)
% PNN�����Ѱ��
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
%% ����spread��ʶ���ʵĶ�Ӧͼ��
figure;
plot(spread,acc);
title('��ͬspread��ʶ����ȷ��');
xlabel('spread');
ylabel('ʶ����ȷ�ʣ�%��');
end