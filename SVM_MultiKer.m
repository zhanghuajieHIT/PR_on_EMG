function [kernel,at]=SVM_MultiKer(trainData,label,kerFunc,testData,at)
% 基于SVM的adaboost
iter=length(kerFunc);%5个核函数组合
kernel=0;
if nargin<4
    [m,~] = size(trainData);
    % 初始化权值D
    D(1,:) = ones(1,m)/m;
    at = zeros(iter,1);
    for i = 1:iter
        [kernelTemp,predictLabel,error]=SVM_kernel(trainData,label,kerFunc{i});%不同核函数的SVM预测
    %计算alpha
        at(i) = 0.5*log((1-error)/max(error,1e-15));
    %更新权值D
        for j=1:m
            D(i+1,j) = D(i,j)*(exp(-1*at(i)*label(j)*predictLabel(j)));%如果是多种分类器联合，则predictLabel(i,j)
        end
        Dsum=sum(D(i+1,:));
        D(i+1,:)=D(i+1,:)/Dsum;
        kernel=kernel+at(i)*kernelTemp;
    end
else
    for i = 1:iter     
        [kernelTemp,~,~]=SVM_kernel(trainData,[],kerFunc{i},testData);
        kernel=kernel+at(i)*kernelTemp;
    end
end

end