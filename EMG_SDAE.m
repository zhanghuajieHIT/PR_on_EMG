function EMG_SDAE
%导入数据
file1='E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\归一化预处理后，overlap为0,len为8\a1.mat';
file2='E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\归一化预处理后，overlap为0,len为8\a2.mat';
dataTrain=load(file1);
dataTest=load(file2);


numTrain=20000;%size(dataTrain.DataStructure.rawEMG,3);
numTest=20000;%size(dataTest.DataStructure.rawEMG,3);  
trainData=zeros(64,numTrain);
trainLabels=zeros(numTrain,1);
testData=zeros(64,numTest);
testLabels=zeros(numTest,1);
trainIndex=randperm(numTrain);
testIndex=randperm(numTest);
for i=1:numTrain%训练的数据数量
    rowID=trainIndex(i);
    trainData(:,i)=reshape(dataTrain.DataStructure.rawEMG(:,:,rowID),64,1);%64的输入格式
    trainLabels(i)=dataTrain.DataStructure.labelID(rowID);
end
for i=1:numTest%测试的数据数量
    rowID=testIndex(i);
    testData(:,i)=reshape(dataTest.DataStructure.rawEMG(:,:,rowID),64,1);
    testLabels(i)=dataTest.DataStructure.labelID(rowID);
end


train_x=trainData';
train_y=trainLabels;
test_x=testData';
test_y=testLabels;

%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)

% minnum=1;
% maxnum=50;
% rightrate=zeros(maxnum-minnum,1);
% for hiddensize=minnum:maxnum    %隐含层节点数

hiddensize=100;
channelnum=8;
motion=14;
rand('state',0)
sae = saesetup([channelnum hiddensize]);
sae.ae{1}.activation_function       = 'ReLU';
sae.ae{1}.learningRate              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
opts.numepochs =   1;
opts.batchsize = 8;
sae = saetrain(sae, train_x, opts);
% visualize(sae.ae{1}.W{1}(:,2:end)')%by ZHJ

% Use the SDAE to initialize a FFNN
nn = nnsetup([channelnum hiddensize motion]);
nn.activation_function              = 'ReLU';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
opts.numepochs =   1;
opts.batchsize = 8;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
% rightrate(hiddensize)=1-er;    %by ZHJ
%assert(er < 0.16, 'Too big error');
1-er
% end
%by ZHJ
%  plot(rightrate);
% [result,local]=max(rightrate);
% 
% display(['resutlt= ',num2str(result),'.']);
% display(['hiddensize= ',num2str(local),'.']);

% %% ex2
% rand('state',0);
% sae = saesetup([8 100 100 100]);
% sae.ae{1}.activation_function       = 'ReLU';
% sae.ae{1}.learningRate              = 1;
% sae.ae{1}.inputZeroMaskedFraction   = 0.5;
% 
% sae.ae{2}.activation_function       = 'ReLU';
% sae.ae{2}.learningRate              = 1;
% sae.ae{2}.inputZeroMaskedFraction   = 0.5;
% 
% opts.numepochs =   1;
% opts.batchsize = 100;
% sae = saetrain(sae, train_x, opts);
% % visualize(sae.ae{1}.W{1}(:,2:end)')
% 
% % Use the SDAE to initialize a FFNN
% nn = nnsetup([8 100 100 13]);
% nn.activation_function              = 'ReLU';
% nn.learningRate                     = 1;
% 
% %add pretrained weights
% nn.W{1} = sae.ae{1}.W{1};
% nn.W{2} = sae.ae{2}.W{1};
% 
% % Train the FFNN
% opts.numepochs =   1;
% opts.batchsize = 100;
% [nn,L,loss] = nntrain(nn, train_x, train_y, opts);
% [er, bad] = nntest(nn, test_x, test_y);
% 1-er
% % assert(er < 0.1, 'Too big error');
% end
