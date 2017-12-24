function [kernel,predictLabel,error]=SVM_kernel(trainData,label,kerFunc,testData)

%先设定核函数的参数
if strcmp(kerFunc,'rbf')
    kernelPara=0.01;
elseif strcmp(kerFunc,'lin')
    kernelPara=[];
elseif strcmp(kerFunc,'poly')
    kernelPara=[0.01 0 3];
elseif strcmp(kerFunc,'sig')
    kernelPara=[0.01 0];
elseif strcmp(kerFunc,'rq')
    kernelPara=1;
end

if nargin<4
    kernel=kernelFunc(trainData,kerFunc,kernelPara);
    cmd='-c 32 -t 4';
    Ktrain=[(1:size(trainData,1))',kernel];
    model = libsvmtrain(label, Ktrain, cmd);
    [predictLabel, acc,~] = libsvmpredict(label, Ktrain, model);
    error=1-acc(1);
else
    kernel=kernelFunc(trainData,kerFunc,kernelPara,testData);
    predictLabel=[];
    error=0;
end