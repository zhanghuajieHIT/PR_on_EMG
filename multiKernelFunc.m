function [kernel,temp]=multiKernelFunc(trainData,testData,Temp,coef,kernelType)
%% 自定义的多核函数
% kernelType:核函数类型，仅有两种组合，高斯核：rbf；线性核：lin；多项式核：poly；
%                       sigmoid核：sig；比如['rbf','ploy']
% trainData:训练数据，样本*维度
% testData:测试数据,样本*维度
% kernelPara:核函数参数
% coef：对应核函数的系数

kernelPara=zeros(length(kernelType),3);%初始化核函数的参数
for i=1:length(kernelType) %对核函数的参数进行赋值
    if strcmp('rbf',cell2mat(kernelType(i)))%如果是rbf核
        kernelPara(i,1)=0.005;
    elseif strcmp('poly',cell2mat(kernelType(i)))%线性核
        kernelPara(i,1:3)=[0.005 0 3];
    elseif strcmp('lin',cell2mat(kernelType(i)))||strcmp('gen',cell2mat(kernelType(i)))||strcmp('logk',cell2mat(kernelType(i)))...
            ||strcmp('power',cell2mat(kernelType(i)))
        kernelPara(i,:)=0;
    elseif strcmp('sig',cell2mat(kernelType(i)))
        kernelPara(i,1:2)=[0.01 0];
    elseif strcmp('rq',cell2mat(kernelType(i)))
        kernelPara(i,1)=50;
    elseif strcmp('cauchy',cell2mat(kernelType(i)))
        kernelPara(i,1)=3;
    elseif strcmp('expk',cell2mat(kernelType(i)))
        kernelPara(i,1)=12.5;
    elseif strcmp('inmk',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.45;
    elseif strcmp('multiq',cell2mat(kernelType(i)))%效果奇差无比
        kernelPara(i,1)=3;
    elseif strcmp('lap',cell2mat(kernelType(i)))
        kernelPara(i,1)=319;
    elseif strcmp('spher',cell2mat(kernelType(i)))
        kernelPara(i,1)=165;
    elseif strcmp('rbf2',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.004;
    elseif strcmp('rbf3',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.003;
    elseif strcmp('rbf4',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.002;
    elseif strcmp('rbfExtend',cell2mat(kernelType(i)))
        kernelPara(i,1:2)=[0.1,0.1];
    end 
end
%% 多核线性组合
% if isempty(testData)
%     for i=1:length(kernelType)
%         Kernel{1,i}=kernelFunc(trainData,cell2mat(kernelType(i)),kernelPara(i,:));
%         normalizeKernel{1,i}=(diag(Kernel{1,i})*diag(Kernel{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
%     end
% else
%     for i=1:length(kernelType)
%         Kernel{1,i}=kernelFunc(trainData,cell2mat(kernelType(i)),kernelPara(i,:),testData);
%         Kernel_test{1,i}=kernelFunc(testData,cell2mat(kernelType(i)),kernelPara(i,:));
%         normalizeKernel{1,i}=(diag(Kernel_test{1,i})*diag(Temp{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
%     end
% end

%% 新方法
Num=fix(size(trainData,2)/length(kernelType));
if isempty(testData)
    for i=1:length(kernelType)
        if i==length(kernelType)
            trainDataTemp=trainData(:,(i-1)*Num+1:end);
        else
            trainDataTemp=trainData(:,(i-1)*Num+1:Num*i);
        end
        Kernel{1,i}=kernelFunc(trainDataTemp,cell2mat(kernelType(i)),kernelPara(i,:));
        normalizeKernel{1,i}=(diag(Kernel{1,i})*diag(Kernel{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
    end
else
    for i=1:length(kernelType)
        if i==length(kernelType)
            trainDataTemp=trainData(:,(i-1)*Num+1:end);
            testDataTemp=testData(:,(i-1)*Num+1:end);
        else
            trainDataTemp=trainData(:,(i-1)*Num+1:Num*i);
            testDataTemp=testData(:,(i-1)*Num+1:Num*i);
        end
        Kernel{1,i}=kernelFunc(trainDataTemp,cell2mat(kernelType(i)),kernelPara(i,:),testDataTemp);
        Kernel_test{1,i}=kernelFunc(testDataTemp,cell2mat(kernelType(i)),kernelPara(i,:));
        normalizeKernel{1,i}=(diag(Kernel_test{1,i})*diag(Temp{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
    end
end


kernel=zeros(length(Kernel{1,1}));
for i=1:length(kernelType)
    kernelTemp=Kernel{1,i}./normalizeKernel{1,i};
    kernel=kernel+coef(i)*kernelTemp;
end
temp=normalizeKernel;

end

