function Model=adaboostNB_train(data,label,iter,oldLabel)
% 基于朴素贝叶斯的adaboost
[m,~] = size(data);
data=data;
label=label;
% 初始化权值D
D(1,:) = ones(1,m)/m;
at = zeros(iter,1);
% [model,bestLabel,error]=buildSVM(data,label,D);
for i = 1:iter
    error(i)=0;
    nb=fitcnb(data,label);
    % 预测
    predict_label(i,:)=predict(nb,data);
    % 计算error
    for j=1:m
       if predict_label(i,j)~=label(j)
           error(i)=error(i)+D(i,j);
       end
    end
    %计算alpha
    at(i) = 0.5*log((1-error(i))/max(error(i),1e-15));
    %更新权值D
    for j=1:m
        D(i+1,j) = D(i,j)*(exp(-1*at(i)*label(j)*predict_label(i,j)));
    end
    Dsum=sum(D(i+1,:));
    D(i+1,:)=D(i+1,:)/Dsum;
    Model.nb{i}=nb;
end

Model.at=at;
% Model.nb=nb;
Model.iter=iter;
Model.oldLabel=oldLabel;

end

