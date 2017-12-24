function [featNew,K]=PCA_opt(featOld,percent,K)
% PCA feature reduction
% matalb�Դ��ĺ���pca
% featOld:feature of the data
% ÿ�д���һ��������ÿ�д���һ��ά�ȣ��ڽ���pca����ǰ��Ҫȥ��ֵ����

% ȥ��ֵ
% feat=bsxfun(@minus,featOld,mean(featOld));% ����feat=featOld-ones(size(featOld,1),1)*mean(featOld);

% pca����,ȷ�����͵�����ά��,K
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

% transMatrix=eigenVectors(:,1:K);%�任����
% featNew=feat*transMatrix;%��ά�������

featNew=scores(:,1:K);

end



