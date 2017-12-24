function [featNew,K]=PCA_opt(featOld,percent,K)
% PCA feature reduction
% matalb自带的函数pca
% featOld:feature of the data
% 每行代表一个样本，每列代表一个维度，在进行pca处理前需要去均值处理

% 去均值
% feat=bsxfun(@minus,featOld,mean(featOld));% 或者feat=featOld-ones(size(featOld,1),1)*mean(featOld);

% pca处理,确定降低到多少维度,K
[eigenVectors,scores,eigenValues] = pca(featOld);

if ~exist('K','var')
k=1;
while k<=length(eigenValues)
    if (sum(eigenValues(1:k))/sum(eigenValues))>=percent
        K=k;
        break;
    end
    k=k+1;
end
end

% transMatrix=eigenVectors(:,1:K);%变换矩阵
% featNew=feat*transMatrix;%降维后的数据

featNew=scores(:,1:K);

end



