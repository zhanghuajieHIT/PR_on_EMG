function [kernel,at]=SVM_MultiKer(trainData,label,kerFunc,testData,at)
% ����SVM��adaboost
iter=length(kerFunc);%5���˺������
kernel=0;
if nargin<4
    [m,~] = size(trainData);
    % ��ʼ��ȨֵD
    D(1,:) = ones(1,m)/m;
    at = zeros(iter,1);
    for i = 1:iter
        [kernelTemp,predictLabel,error]=SVM_kernel(trainData,label,kerFunc{i});%��ͬ�˺�����SVMԤ��
    %����alpha
        at(i) = 0.5*log((1-error)/max(error,1e-15));
    %����ȨֵD
        for j=1:m
            D(i+1,j) = D(i,j)*(exp(-1*at(i)*label(j)*predictLabel(j)));%����Ƕ��ַ��������ϣ���predictLabel(i,j)
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