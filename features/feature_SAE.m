function Sparse_feature=feature_SAE(trainData)
%% Extracted the spares feature
% by zhj
% 2016/11/24
%==================================%
%% �������
% inputSize = 8 * 300;
inputSize = 8;
numClasses = 14;
hiddenSizeL1 = 50;    % Layer 1 Hidden Size
hiddenSizeL2 = 20;    % Layer 2 Hidden Size
sparsityParam = 0.2;   % desired average activation of the hidden units.
                       % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		               %  in the lecture notes). 
lambda = 3e-3;         % weight decay parameter       
beta = 3;     

%% ��һ��������
oneTheta = initializeParameters(hiddenSizeL1, inputSize);
addpath minFunc/
autoencoderOptions.Method = 'lbfgs';  % Here, we use L-BFGS to optimize our cost
                                      % function. Generally, for minFunc to work, you
                                      % need a function pointer with two outputs: the
                                      % function value and the gradient. In our problem,
                                      % sparseAutoencoderCost.m satisfies this.
autoencoderOptions.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
autoencoderOptions.display = 'on';

% if exist('oneOptTheta.mat','file')==2   
%     load('oneOptTheta.mat');
% else
[oneOptTheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, inputSize, hiddenSizeL1, ...
                                   lambda, sparsityParam, beta, trainData), ...
                                   oneTheta, autoencoderOptions);                        
% save('oneOptTheta.mat','oneOptTheta');
% end
% ����
[oneFeatures] = feedForwardAutoencoder(oneOptTheta, hiddenSizeL1, ...
                                        inputSize, trainData);
  
%% �ڶ���������                                    
twoTheta = initializeParameters(hiddenSizeL2, hiddenSizeL1);

% if exist('twoOptTheta.mat','file')==2   
%     load('twoOptTheta.mat');
% else
[twoOptTheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, hiddenSizeL1, hiddenSizeL2, ...
                                   lambda, sparsityParam, beta, oneFeatures), ...
                                   twoTheta, autoencoderOptions);                        
% save('twoOptTheta.mat','twoOptTheta');
% end
% ����
[twoFeatures] = feedForwardAutoencoder(twoOptTheta, hiddenSizeL2, ...
                                        hiddenSizeL1, oneFeatures);
                                    
%% ����������ֻ��Ҫ���һ��������õ���������
% save('D:\MatWorkSpace\��������\oneFeatures.mat','oneFeatures');
% save('D:\MatWorkSpace\��������\twoFeatures.mat','twoFeatures');
% save('D:\MatWorkSpace\��������\Sparse_feature.mat','twoFeatures');
Sparse_feature=twoFeatures;

end
