function Model=adaboostBP_train(data,label,iter,oldLabel)
% ����BP��adaboost
[m,~] = size(data);
data=data';
label=label';
% ��ʼ��ȨֵD
D(1,:) = ones(1,m)/m;
at = zeros(iter,1);
% [model,bestLabel,error]=buildSVM(data,label,D);
for i = 1:iter
    error(i)=0;
    % BP�����繹��
    net=newff(data,label,10);
    net.trainParam.epochs=4;
    net.trainParam.lr=0.1;
    net.trainParam.goal=0.00004;
    % BP������ѵ��
    net=train(net,data,label);
    % Ԥ��
    predictTrain(i,:)=sim(net,data);
    kk1=find(predictTrain(i,:)>0);
    kk2=find(predictTrain(i,:)<0);
    aa(kk1)=1;%��Ӧ�Ķ�ԭlabel��oldLabel(1)
    aa(kk2)=-1;%��Ӧ�Ķ�ԭlabel��oldLabel(2)
    % ����error
    for j=1:m
       if aa(j)~=label(j)
           error(i)=error(i)+D(i,j);
       end
    end
    %����alpha
    at(i) = 0.5*log((1-error(i))/max(error(i),1e-15));
    %����ȨֵD
    for j=1:m
        D(i+1,j) = D(i,j)*(exp(-1*at(i)*aa(j)*predictTrain(i,j)));
    end
    Dsum=sum(D(i+1,:));
    D(i+1,:)=D(i+1,:)/Dsum;
    Model.net{i}=net;
end

Model.at=at;
% Model.net=net;
Model.iter=iter;
Model.oldLabel=oldLabel;

end

