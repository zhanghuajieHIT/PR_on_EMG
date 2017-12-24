function Model=adaboostSVM_train(data,label,iter,oldLabel)
% 基于SVM的adaboost
[m,~] = size(data);
% 初始化权值D
D(1,:) = ones(1,m)/m;
at = zeros(iter,1);
for i = 1:iter
%     [model,predictLabel,error]=buildSVM(data,label,D(i,:));%如果是多种分类器联合，则predictLabel(i,:)
    [model,predictLabel,error]=buildSVM(data,label,D(i,:),i);
    %计算alpha
    at(i) = 0.5*log((1-error)/max(error,1e-15));
    %更新权值D
    for j=1:m
        D(i+1,j) = D(i,j)*(exp(-1*at(i)*label(j)*predictLabel(j)));%如果是多种分类器联合，则predictLabel(i,j)
    end
    Dsum=sum(D(i+1,:));
    D(i+1,:)=D(i+1,:)/Dsum;
    Model.model{i}=model;
end

Model.at=at;
% Model.model=model;
Model.iter=iter;
Model.oldLabel=oldLabel;
end