% function delsysData_example_SAE
clc;
clear;

train1=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\a1.mat');
train2=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\a2.mat');
train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
test1=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\c1.mat');
test2=load('E:\实验\Delsys数据采集\实验数据\zhj20161219\无归一化预处理后，overlap为100,len为300\c2.mat');
test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
trainLen=size(train.DataStructure.rawEMG,3);
trainData=zeros(trainLen,8);    %注意特征的列数为8，不同的特征可能不一样
testLen=size(test.DataStructure.rawEMG,3);
testData=zeros(testLen,8);
fun='feature_MAV';
for i=1:trainLen
    trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');
end
trainLabel=train.DataStructure.labelID;
trainData=mapminmax(trainData',0,5)';%归一化

for i=1:testLen
    testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');
end
testLabel=test.DataStructure.labelID;
testData=mapminmax(testData',0,5)';%归一化


train_x=trainData;
test_x=testData;
train_y=zeros(length(trainLabel),14);
test_y=zeros(length(testLabel),14);
for i=1:length(trainLabel)
    train_y(i,trainLabel(i))=trainLabel(i);
end
for i=1:length(testLabel)
    test_y(i,testLabel(i))=testLabel(i);
end


%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
rand('state',0)
sae = saesetup([8 16]);%调用saesetup设置网络参数，结构为[784 100]的两层网络，结果为 sae.ae{1}=nnsetup([784 10 784])
%修改网络参数
sae.ae{1}.activation_function       = 'sigm';%激活函数类型
sae.ae{1}.learningRate              = 0.5;%学习率
sae.ae{1}.inputZeroMaskedFraction   = 1;%输入加噪率
opts.numepochs =   1;%训练迭代次数
opts.batchsize = 50;
sae = saetrain(sae, train_x, opts);%对各个隐含层进行逐层训练，本例中隐含层仅有1层、100个节点，输入输出都是tran_x。每次进行nnstrain来训练隐含层都为三层网络，输入层和输出层一样
visualize(sae.ae{1}.W{1}(:,2:end)')%对第一组权值进行可视化，第一组权值W{1}用于编码，第二组W{2}用于解码

% Use the SDAE to initialize a FFNN   %初始化网络
nn = nnsetup([8 16 14]);%设置整个网络，结构为[784 100 10]，输入节点为784，隐含层节点为100，输出10个节点
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};%上面步骤中用于编码的W{1}（包括阈值b和权值W）赋给此网络

% Train the FFNN    %训练前向网络
opts.numepochs =   1;%设置训练次数
opts.batchsize = 10;
nn = nntrain(nn, train_x, train_y, opts);%调用nntrain来训练整个网络，此时的期望输出时tran_y，因此为有监督的训练
[er, bad] = nntest(nn, test_x, test_y);%网络测试
1-er    %计算正确率
assert(er < 0.16, 'Too big error');
