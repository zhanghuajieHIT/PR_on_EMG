function Model=adaboostSVM_train(data,label,iter,oldLabel)
% ����SVM��adaboost
[m,~] = size(data);
% ��ʼ��ȨֵD
D(1,:) = ones(1,m)/m;
at = zeros(iter,1);
for i = 1:iter
%     [model,predictLabel,error]=buildSVM(data,label,D(i,:));%����Ƕ��ַ��������ϣ���predictLabel(i,:)
    [model,predictLabel,error]=buildSVM(data,label,D(i,:),i);
    %����alpha
    at(i) = 0.5*log((1-error)/max(error,1e-15));
    %����ȨֵD
    for j=1:m
        D(i+1,j) = D(i,j)*(exp(-1*at(i)*label(j)*predictLabel(j)));%����Ƕ��ַ��������ϣ���predictLabel(i,j)
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