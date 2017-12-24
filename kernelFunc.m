function kernel=kernelFunc(trainData,kernelType,kernelPara,testData)
%% 自定义的核函数
% kernelType:核函数类型，有如下几种：
% 高斯核：rbf;-----------------------线性核：lin;----------------多项式核：poly；
% sigmoid核：sig；-------------------Rational Quadratic Kernel:rq;
% Generalized T-Student Kernel:gen;----Cauchy Kernel:cauchy
% Log Kernel:logk;-----------Power Kernel:power;-----Exponential Kernel:expk;
% Inverse Multiquadric Kernel:inmk-------Multiquadric Kernel:multiq;
% Laplacian Kernel:lap;----------Spherical Kernel:spher

% trainData:训练数据，样本*维度
% testData:测试数据,样本*维度
% kernelPara:核函数参数

N=size(trainData,1);

%% rbf
if strcmp(kernelType,'rbf')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
%         kernel=exp(-kernel./(2*gamma^2));
    else        
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
%         kernel=exp(-kernel./(2*gamma^2));
    end

%% lin
elseif strcmp(kernelType,'lin')
    if nargin<4
        kernel=trainData*trainData';
    else
        kernel=testData*trainData';
    end

%% poly
elseif strcmp(kernelType,'poly')
    gamma=kernelPara(1);
    coef=kernelPara(2);
    degree=kernelPara(3);
    if nargin<4
        kernel=(gamma*(trainData*trainData')+coef).^degree;
    else
        kernel=(gamma*(testData*trainData')+coef).^degree;
    end
    
%% sigmoid
elseif strcmp(kernelType,'sig')
    gamma=kernelPara(1);
    coef=kernelPara(2);
    if nargin<4
        kernel=tanh(gamma*(trainData*trainData')+coef);
    else
        kernel=tanh(gamma*(testData*trainData')+coef);
    end

%% Rational Quadratic Kernel
elseif strcmp(kernelType,'rq')
    c=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=1-kernel./(kernel+c);
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=1-kernel./(kernel+c);
    end
    
%% Generalized T-Student Kernel
elseif strcmp(kernelType,'gen')
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=1./(1+kernel);
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=1./(1+kernel);
    end
    
%% Cauchy Kernel
elseif strcmp(kernelType,'cauchy')
    siga=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=1./((1+kernel)/siga);
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=1./((1+kernel)/siga);
    end
    
%% Log Kernel
elseif strcmp(kernelType,'logk')%d=2
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=-log10(kernel+1);
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=-log10(kernel+1);
    end 
    
%% Power Kernel
elseif strcmp(kernelType,'power')
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=-kernel;
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=-kernel;
    end
    
%% Inverse Multiquadric Kernel
elseif strcmp(kernelType,'inmk')
    c=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=1./((kernel+c*c).^0.5);
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=1./((kernel+c*c).^0.5);
    end
 
%% Multiquadric Kernel
elseif strcmp(kernelType,'multiq')
    c=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=(kernel+c*c).^0.5;
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=(kernel+c*c).^0.5;
    end
    
%% Exponential Kernel
elseif strcmp(kernelType,'expk')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=exp((-kernel.^0.5)/(2*gamma*gamma));
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=exp((-kernel.^0.5)/(2*gamma*gamma));
    end
    
%% Laplacian Kernel
elseif strcmp(kernelType,'lap')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=exp((-kernel.^0.5)/gamma);
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=exp((-kernel.^0.5)/gamma);
    end

%% Spherical Kernel
elseif strcmp(kernelType,'spher')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=1-1.5*(kernel/gamma)+0.5*(kernel/gamma).^3;
    else
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=1-1.5*(kernel/gamma)+0.5*(kernel/gamma).^3;
    end
    
elseif strcmp(kernelType,'rbf2')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
    else        
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
    end
    
elseif strcmp(kernelType,'rbf3')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
    else        
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
    end
    
elseif strcmp(kernelType,'rbf4')
    gamma=kernelPara(1);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
    else        
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=exp(-kernel.*gamma);%libSVM中的rbf形式
    end
elseif strcmp(kernelType,'rbfExtend')
    gamma1=kernelPara(1);
    gamma2=kernelPara(2);
    if nargin<4
        Temp=sum(trainData.^2,2)*ones(1,N);
        kernel=Temp+Temp'-2*(trainData*trainData');
        kernel=(2*gamma1*gamma2.*(gamma1^2+gamma2^2)).^(4/2)*exp(-2*kernel.*(gamma1^2+gamma2^2));
    else        
        Temp1=sum(testData.^2,2)*ones(1,size(trainData,1));
        Temp2=sum(trainData.^2,2)*ones(1,size(testData,1));
        kernel=Temp1+Temp2'-2*testData*trainData';
        kernel=(2*gamma1*gamma2.*(gamma1^2+gamma2^2)).^(2/2)*exp(-2*kernel.*(gamma1^2+gamma2^2));
    end
    
end

