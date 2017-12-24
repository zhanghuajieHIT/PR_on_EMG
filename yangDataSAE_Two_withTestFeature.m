function [result1,result2]=yangDataSAE_Two_withTestFeature(trainData,trainLabels,testData,testLabels)
%% STEP 0: Here we provide the relevant parameters values that will
%  allow your sparse autoencoder to get good filters; you do not need to 
%  change the parameters below.
inputSize = 8 * 256;
numClasses = 7;
hiddenSizeL1 = 100;    % Layer 1 Hidden Size
hiddenSizeL2 = 20;    % Layer 2 Hidden Size
sparsityParam = 0.2;   % desired average activation of the hidden units.
                       % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		               %  in the lecture notes). 
lambda = 3e-3;         % weight decay parameter       
beta = 3;              % weight of sparsity penalty term       

%%======================================================================
%% STEP 1: Load data from the MNIST database
%
%%======================================================================
%% STEP 2: Train the first sparse autoencoder
sae1Theta_train = initializeParameters(hiddenSizeL1, inputSize);

%% ---------------------- YOUR CODE HERE  ---------------------------------
addpath minFunc/
autoencoderOptions.Method = 'lbfgs';  % Here, we use L-BFGS to optimize our cost
                                      % function. Generally, for minFunc to work, you
                                      % need a function pointer with two outputs: the
                                      % function value and the gradient. In our problem,
                                      % sparseAutoencoderCost.m satisfies this.
autoencoderOptions.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
autoencoderOptions.display = 'on';

if exist('sae1OptTheta_train.mat','file')==2   
    load('sae1OptTheta_train.mat');
else
[sae1OptTheta_train, cost] = minFunc( @(p) sparseAutoencoderCost(p, inputSize, hiddenSizeL1, ...
                                   lambda, sparsityParam, beta, trainData), ...
                                   sae1Theta_train, autoencoderOptions);                        
save('sae1OptTheta_train.mat','sae1OptTheta_train');
end

%%======================================================================
%% STEP 2: Train the second sparse autoencoder
[sae1Features_train] = feedForwardAutoencoder(sae1OptTheta_train, hiddenSizeL1, ...
                                        inputSize, trainData);

%  Randomly initialize the parameters
sae2Theta_train = initializeParameters(hiddenSizeL2, hiddenSizeL1);

%% ---------------------- YOUR CODE HERE  ---------------------------------
if exist('sae2OptTheta_train.mat','file')==2   
    load('sae2OptTheta_train.mat');
else
[sae2OptTheta_train, cost] = minFunc( @(p) sparseAutoencoderCost(p, hiddenSizeL1, hiddenSizeL2, ...
                                   lambda, sparsityParam, beta, sae1Features_train), ...
                                   sae2Theta_train, autoencoderOptions);                        
save('sae2OptTheta_train.mat','sae2OptTheta_train');
end
                          
%%======================================================================
%% STEP 3: Train the softmax classifier
[sae2Features_train] = feedForwardAutoencoder(sae2OptTheta_train, hiddenSizeL2, ...
                                        hiddenSizeL1, sae1Features_train);

%% 测试数据
%% STEP 2: Train the first sparse autoencoder
sae1Theta_test = initializeParameters(hiddenSizeL1, inputSize);

%% ---------------------- YOUR CODE HERE  ---------------------------------
addpath minFunc/
autoencoderOptions.Method = 'lbfgs';  % Here, we use L-BFGS to optimize our cost
                                      % function. Generally, for minFunc to work, you
                                      % need a function pointer with two outputs: the
                                      % function value and the gradient. In our problem,
                                      % sparseAutoencoderCost.m satisfies this.
autoencoderOptions.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
autoencoderOptions.display = 'on';

if exist('sae1OptTheta_test.mat','file')==2   
    load('sae1OptTheta_test.mat');
else
[sae1OptTheta_test, cost] = minFunc( @(p) sparseAutoencoderCost(p, inputSize, hiddenSizeL1, ...
                                   lambda, sparsityParam, beta, testData), ...
                                   sae1Theta_test, autoencoderOptions);                        
save('sae1OptTheta_test.mat','sae1OptTheta_test');
end

%%======================================================================
%% STEP 2: Train the second sparse autoencoder
[sae1Features_test] = feedForwardAutoencoder(sae1OptTheta_test, hiddenSizeL1, ...
                                        inputSize, testData);

%  Randomly initialize the parameters
sae2Theta_test = initializeParameters(hiddenSizeL2, hiddenSizeL1);

%% ---------------------- YOUR CODE HERE  ---------------------------------
if exist('sae2OptTheta_test.mat','file')==2   
    load('sae2OptTheta_test.mat');
else
[sae2OptTheta_test, cost] = minFunc( @(p) sparseAutoencoderCost(p, hiddenSizeL1, hiddenSizeL2, ...
                                   lambda, sparsityParam, beta, sae1Features_test), ...
                                   sae2Theta_test, autoencoderOptions);                        
save('sae2OptTheta_test.mat','sae2OptTheta_test');
end
                          
%%======================================================================
%% STEP 3: Train the softmax classifier
[sae2Features_test] = feedForwardAutoencoder(sae2OptTheta_test, hiddenSizeL2, ...
                                        hiddenSizeL1, sae1Features_test);

%% ---------------------- YOUR CODE HERE  ---------------------------------
softmaxOptions.maxIter = 100;
lambdaSoftmax = 1e-4;   % Weight decay parameter for Softmax
trainNumber = size(sae2Features_train,2);
softmaxInuptSize = hiddenSizeL2+1;  % softmaxTrain 默认数据中已包含截距项
softmaxInput = [sae2Features_train;ones(1,trainNumber)];  % softmaxTrain 默认数据中已包含截距项

softmaxModel = softmaxTrain(softmaxInuptSize, numClasses, lambdaSoftmax, softmaxInput, trainLabels, softmaxOptions); 
saeSoftmaxOptTheta = softmaxModel.optTheta(:);

% -------------------------------------------------------------------------



%%======================================================================
%% STEP 5: Finetune softmax model

% Implement the stackedAECost to give the combined cost of the whole model
% then run this cell.

% Initialize the stack using the parameters learned
stack = cell(2,1);
stack{1}.w = reshape(sae1OptTheta_train(1:hiddenSizeL1*inputSize), ...
                     hiddenSizeL1, inputSize);
stack{1}.b = sae1OptTheta_train(2*hiddenSizeL1*inputSize+1:2*hiddenSizeL1*inputSize+hiddenSizeL1);
stack{2}.w = reshape(sae2OptTheta_train(1:hiddenSizeL2*hiddenSizeL1), ...
                     hiddenSizeL2, hiddenSizeL1);
stack{2}.b = sae2OptTheta_train(2*hiddenSizeL2*hiddenSizeL1+1:2*hiddenSizeL2*hiddenSizeL1+hiddenSizeL2);

% Initialize the parameters for the deep model
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [ saeSoftmaxOptTheta ; stackparams ];

%% ---------------------- YOUR CODE HERE  ---------------------------------
%  Instructions: Train the deep network, hidden size here refers to the '
%                dimension of the input to the classifier, which corresponds 
%                to "hiddenSizeL2".
%
%
if exist('stackedAEOptTheta.mat','file')==2   
    load('stackedAEOptTheta.mat');
else
[stackedAEOptTheta, cost] = minFunc( @(p) stackedAECost(p, inputSize, hiddenSizeL2, ...
                                  numClasses, netconfig, lambdaSoftmax, trainData, trainLabels), ...
                                  stackedAETheta, autoencoderOptions);  %微调时将trainData改为特征呢？
 save('stackedAEOptTheta.mat','stackedAEOptTheta');
end
% -------------------------------------------------------------------------



%%======================================================================
%% STEP 6: Test 
%  Instructions: You will need to complete the code in stackedAEPredict.m
%                before running this part of the code
%

% Get labelled test images
% Note that we apply the same kind of preprocessing as the training set

%by zhj
% testLabels(testLabels == 0) = 10; % Remap 0 to 10
% 使用未经过 fine-tune 参数
[pred] = stackedAEPredict(stackedAETheta, inputSize, hiddenSizeL2, ...
                          numClasses, netconfig, sae2Features_test);

acc = mean(testLabels(:) == pred(:));
fprintf('Before Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

result1=acc;

% 使用经过 fine-tune 参数
[pred] = stackedAEPredict(stackedAEOptTheta, inputSize, hiddenSizeL2, ...
                          numClasses, netconfig, sae2Features_test);

acc = mean(testLabels(:) == pred(:));
fprintf('After Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

result2=acc;

% Accuracy is the proportion of correctly classified images
% The results for our implementation were:
%
% Before Finetuning Test Accuracy: 87.7%
% After Finetuning Test Accuracy:  97.6%
%
% If your values are too low (accuracy less than 95%), you should check 
% your code for errors, and make sure you are training on the 
% entire data set of 60000 28x28 training images 
% (unless you modified the loading code, this should be the case)
