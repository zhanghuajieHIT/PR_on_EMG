function [result1,result2]=yangDataSAE_Two(trainData,trainLabels,testData,testLabels,dataTrainName,FUN)
%% STEP 0: Here we provide the relevant parameters values that will
%  allow your sparse autoencoder to get good filters; you do not need to 
%  change the parameters below.
inputSize = 48;
numClasses = 14;
hiddenSizeL1 = 150;    % Layer 1 Hidden Size
hiddenSizeL2 = 80;    % Layer 2 Hidden Size
sparsityParam = 0.5;   % desired average activation of the hidden units.
                       % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		               %  in the lecture notes). 
lambda = 3e-3;         % weight decay parameter   L2正则化    
beta = 3;              % weight of sparsity penalty term       

%%======================================================================
%% STEP 1: Load data from the MNIST database
%


% file='E:\实验\杨老师数据\EMG data.mat';
% load(file);

% %% 去均值,均值约为1.2
% for i=1:length(DataStructure)%i从1到9
%     DataStructure{1,i}.rawEMG=DataStructure{1,i}.rawEMG-1.2;
% end

% % 归一化
% 
% for i=1:length(DataStructure{1,1}.rawEMG)
%     train_data(:,:,i)=mapminmax(DataStructure{1,1}.rawEMG(:,:,i),0,1); 
% end
% 
% 
% for i=1:length(DataStructure{1,6}.rawEMG)
%     test_data(:,:,i)=mapminmax(DataStructure{1,6}.rawEMG(:,:,i),0,1);     
% end


% %% 确定训练和测试数据
% % [~,~,numTrain]=size(DataStructure{1,1}.rawEMG);
% % [~,~,num]=size(data);
% [~,~,numTrain]=size(train_data);
% [~,~,numTest]=size(test_data);
% % numTrain=2000;
% % numTest=num-numTrain;
% train_x=zeros(2048,numTrain);
% train_y=zeros(numTrain,1);%7种动作
% for i=1:numTrain%训练的数据数量
% %     rowID=randi(numTrain);
%     rowID=randi(numTrain);
%     train_x(:,i)=reshape(train_data(:,:,rowID),2048,1);%8*256的输入格式
%     train_y(i)=DataStructure{1,1}.labelID(rowID);
% end
% trainData=train_x;
% trainLabels=train_y;
% 
% % [~,~,numTest]=size(DataStructure{1,2}.rawEMG);
% test_x=zeros(2048,numTest);
% test_y=zeros(numTest,1);
% for i=1:numTest
%     rowID=randi(numTest);
% %     rowID=randi(num);
%     test_x(:,i)=reshape(test_data(:,:,rowID),2048,1);
%     test_y(i)=DataStructure{1,6}.labelID(rowID);
% end
% testData=test_x;
% testLabels=test_y;



%%======================================================================
%% STEP 2: Train the first sparse autoencoder
%  This trains the first sparse autoencoder on the unlabelled STL training
%  images.
%  If you've correctly implemented sparseAutoencoderCost.m, you don't need
%  to change anything here.


%  Randomly initialize the parameters
sae1Theta = initializeParameters(hiddenSizeL1, inputSize);

%% ---------------------- YOUR CODE HERE  ---------------------------------
%  Instructions: Train the first layer sparse autoencoder, this layer has
%                an hidden size of "hiddenSizeL1"
%                You should store the optimal parameters in sae1OptTheta

%  Use minFunc to minimize the function
addpath minFunc/
autoencoderOptions.Method = 'lbfgs';  % Here, we use L-BFGS to optimize our cost
                                      % function. Generally, for minFunc to work, you
                                      % need a function pointer with two outputs: the
                                      % function value and the gradient. In our problem,
                                      % sparseAutoencoderCost.m satisfies this.
autoencoderOptions.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
autoencoderOptions.display = 'on';

if exist([FUN,dataTrainName,'sae1OptTheta.mat'],'file')==2   
    load([FUN,dataTrainName,'sae1OptTheta.mat']);
else
[sae1OptTheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, inputSize, hiddenSizeL1, ...
                                   lambda, sparsityParam, beta, trainData), ...
                                   sae1Theta, autoencoderOptions);                        
save([FUN,dataTrainName,'sae1OptTheta.mat'],'sae1OptTheta');
end
                          
% Visualize weights
% figure('name','Features learned by hidden layer 1');
W11 = reshape(sae1OptTheta(1 : hiddenSizeL1*inputSize), hiddenSizeL1, inputSize);
% display_network(W11');
% print -djpeg weights_with_sae1.jpg 


% -------------------------------------------------------------------------

%%======================================================================
%% STEP 2: Train the second sparse autoencoder
%  This trains the second sparse autoencoder on the first autoencoder
%  featurse.
%  If you've correctly implemented sparseAutoencoderCost.m, you don't need
%  to change anything here.

[sae1Features] = feedForwardAutoencoder(sae1OptTheta, hiddenSizeL1, ...
                                        inputSize, trainData);

%  Randomly initialize the parameters
sae2Theta = initializeParameters(hiddenSizeL2, hiddenSizeL1);

%% ---------------------- YOUR CODE HERE  ---------------------------------
%  Instructions: Train the second layer sparse autoencoder, this layer has
%                an hidden size of "hiddenSizeL2" and an inputsize of
%                "hiddenSizeL1"
%
%                You should store the optimal parameters in sae2OptTheta

%  Use minFunc to minimize the function
if exist([FUN,dataTrainName,'sae2OptTheta.mat'],'file')==2   
    load([FUN,dataTrainName,'sae2OptTheta.mat']);
else
[sae2OptTheta, cost] = minFunc( @(p) sparseAutoencoderCost(p, hiddenSizeL1, hiddenSizeL2, ...
                                   lambda, sparsityParam, beta, sae1Features), ...
                                   sae2Theta, autoencoderOptions);                        
save([FUN,dataTrainName,'sae2OptTheta.mat'],'sae2OptTheta');
end
                          
% Visualize weights
% figure('name','Features learned by hidden layer 2');
W21 = reshape(sae2OptTheta(1 : hiddenSizeL2*hiddenSizeL1), hiddenSizeL2, hiddenSizeL1);
% display_network((W21*W11)');    % 权值内积
% print -djpeg weights_with_sae1&2.jpg 

% -------------------------------------------------------------------------


%%======================================================================
%% STEP 3: Train the softmax classifier
%  This trains the sparse autoencoder on the second autoencoder features.
%  If you've correctly implemented softmaxCost.m, you don't need
%  to change anything here.

[sae2Features] = feedForwardAutoencoder(sae2OptTheta, hiddenSizeL2, ...
                                        hiddenSizeL1, sae1Features);
save([FUN,dataTrainName,'Sparse_feature.mat'],'sae2Features');
%  Randomly initialize the parameters
%  saeSoftmaxTheta = 0.005 * randn((hiddenSizeL2+1) * numClasses, 1);


%% ---------------------- YOUR CODE HERE  ---------------------------------
%  Instructions: Train the softmax classifier, the classifier takes in
%                input of dimension "hiddenSizeL2" corresponding to the
%                hidden layer size of the 2nd layer.
%
%                You should store the optimal parameters in saeSoftmaxOptTheta 
%
%  NOTE: If you used softmaxTrain to complete this part of the exercise,
%        set saeSoftmaxOptTheta = softmaxModel.optTheta(:);

softmaxOptions.maxIter = 100;
lambdaSoftmax = 1e-4;   % Weight decay parameter for Softmax
trainNumber = size(sae2Features,2);
softmaxInuptSize = hiddenSizeL2+1;  % softmaxTrain 默认数据中已包含截距项
softmaxInput = [sae2Features;ones(1,trainNumber)];  % softmaxTrain 默认数据中已包含截距项

softmaxModel = softmaxTrain(softmaxInuptSize, numClasses, lambdaSoftmax, softmaxInput, trainLabels, softmaxOptions); 
saeSoftmaxOptTheta = softmaxModel.optTheta(:);

% -------------------------------------------------------------------------



%%======================================================================
%% STEP 5: Finetune softmax model

% Implement the stackedAECost to give the combined cost of the whole model
% then run this cell.

% Initialize the stack using the parameters learned
stack = cell(2,1);
stack{1}.w = reshape(sae1OptTheta(1:hiddenSizeL1*inputSize), ...
                     hiddenSizeL1, inputSize);
stack{1}.b = sae1OptTheta(2*hiddenSizeL1*inputSize+1:2*hiddenSizeL1*inputSize+hiddenSizeL1);
stack{2}.w = reshape(sae2OptTheta(1:hiddenSizeL2*hiddenSizeL1), ...
                     hiddenSizeL2, hiddenSizeL1);
stack{2}.b = sae2OptTheta(2*hiddenSizeL2*hiddenSizeL1+1:2*hiddenSizeL2*hiddenSizeL1+hiddenSizeL2);

% Initialize the parameters for the deep model
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [ saeSoftmaxOptTheta ; stackparams ];

%% ---------------------- YOUR CODE HERE  ---------------------------------
%  Instructions: Train the deep network, hidden size here refers to the '
%                dimension of the input to the classifier, which corresponds 
%                to "hiddenSizeL2".
%
%
if exist([FUN,dataTrainName,'stackedAEOptTheta.mat'],'file')==2   
    load([FUN,dataTrainName,'stackedAEOptTheta.mat']);
else
[stackedAEOptTheta, cost] = minFunc( @(p) stackedAECost(p, inputSize, hiddenSizeL2, ...
                                  numClasses, netconfig, lambdaSoftmax, trainData, trainLabels), ...
                                  stackedAETheta, autoencoderOptions);  
 save([FUN,dataTrainName,'stackedAEOptTheta.mat'],'stackedAEOptTheta');
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
                          numClasses, netconfig, testData);

acc = mean(testLabels(:) == pred(:));
fprintf('Before Finetuning Test Accuracy: %0.3f%%\n', acc * 100);

result1=acc;

% 使用经过 fine-tune 参数
[pred] = stackedAEPredict(stackedAEOptTheta, inputSize, hiddenSizeL2, ...
                          numClasses, netconfig, testData);

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
