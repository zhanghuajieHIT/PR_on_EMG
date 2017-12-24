function Model=adaboostBP_train(data,label,iter,oldLabel)
% 基于BP的adaboost
[m,~] = size(data);
data=data';
label=label';
% 初始化权值D
D(1,:) = ones(1,m)/m;
at = zeros(iter,1);
% [model,bestLabel,error]=buildSVM(data,label,D);
for i = 1:iter
    error(i)=0;
    % BP神经网络构建
    net=newff(data,label,10);
    net.trainParam.epochs=4;
    net.trainParam.lr=0.1;
    net.trainParam.goal=0.00004;
    % BP神经网络训练
    net=train(net,data,label);
    % 预测
    predictTrain(i,:)=sim(net,data);
    kk1=find(predictTrain(i,:)>0);
    kk2=find(predictTrain(i,:)<0);
    aa(kk1)=1;%对应的额原label是oldLabel(1)
    aa(kk2)=-1;%对应的额原label是oldLabel(2)
    % 计算error
    for j=1:m
       if aa(j)~=label(j)
           error(i)=error(i)+D(i,j);
       end
    end
    %计算alpha
    at(i) = 0.5*log((1-error(i))/max(error(i),1e-15));
    %更新权值D
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

