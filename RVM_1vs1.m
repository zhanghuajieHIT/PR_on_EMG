function [predictLabel]=RVM_1vs1(kernel_,width,maxIts,trainData,trainLabel,testData,testLabel)
%实现RVM的1vs1分类

% Set verbosity of output (0 to 4)
setEnvironment('Diagnostic','verbosity',3);
% Set file ID to write to (1 = stdout)
setEnvironment('Diagnostic','fid',1);

%
% Set default values for data and model
% 
useBias	= true;
%
% rand('state',1)
% if nargin==0
%   % Some acceptable defaults
%   % 
%   N		= 100;
%   kernel_	= 'gauss';
%   width		= 0.5;
%   maxIts	= 1000;
% end
monIts		= round(maxIts/10);
% N		= min([250 N]); % training set has fixed size of 250
N=size(trainData,1);
Nt		= length(testLabel);%测试样本的数目
%
%% load train data

X=trainData;
t=trainLabel;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% COL_data1	= 'k';
% COL_data2	= 0.75*[0 1 0];
% COL_boundary50	= 'r';
% COL_boundary75	= 0.5*ones(1,3);
% COL_rv		= 'r';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Set up initial hyperparameters - precise settings should not be critical
% 
initAlpha	= (1/N)^3;
% Set beta to zero for classification
initBeta	= 0;	
%
% "Train" a sparse Bayes kernel-based model (relevance vector machine)
% 
[weights, used, bias, marginal, alpha, beta, gamma] = ...
    SB1_RVM(X,t,initAlpha,initBeta,kernel_,width,useBias,maxIts,monIts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%% Load test data

Xtest=testData;
ttest=testLabel;
%
% Compute RVM over test data and calculate error
% 
PHI	= SB1_KernelFunction(Xtest,X(used,:),kernel_,width);
y_rvm	= PHI*weights + bias;
predictLabel=y_rvm;
errs	= sum(y_rvm(ttest==0)>0) + sum(y_rvm(ttest==1)<=0);%大于0的为1类，小于0的为0类
SB1_Diagnostic(1,'RVM CLASSIFICATION test error: %.2f%%\n', errs/Nt*100)

end

