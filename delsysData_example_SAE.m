% function delsysData_example_SAE
clc;
clear;

train1=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a1.mat');
train2=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\a2.mat');
train.DataStructure.rawEMG=cat(3,train1.DataStructure.rawEMG,train2.DataStructure.rawEMG);
train.DataStructure.labelID=cat(1,train1.DataStructure.labelID,train2.DataStructure.labelID);
test1=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\c1.mat');
test2=load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\c2.mat');
test.DataStructure.rawEMG=cat(3,test1.DataStructure.rawEMG,test2.DataStructure.rawEMG);
test.DataStructure.labelID=cat(1,test1.DataStructure.labelID,test2.DataStructure.labelID);

%% feature extrated  
trainLen=size(train.DataStructure.rawEMG,3);
trainData=zeros(trainLen,8);    %ע������������Ϊ8����ͬ���������ܲ�һ��
testLen=size(test.DataStructure.rawEMG,3);
testData=zeros(testLen,8);
fun='feature_MAV';
for i=1:trainLen
    trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)');
end
trainLabel=train.DataStructure.labelID;
trainData=mapminmax(trainData',0,5)';%��һ��

for i=1:testLen
    testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)');
end
testLabel=test.DataStructure.labelID;
testData=mapminmax(testData',0,5)';%��һ��


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
sae = saesetup([8 16]);%����saesetup��������������ṹΪ[784 100]���������磬���Ϊ sae.ae{1}=nnsetup([784 10 784])
%�޸��������
sae.ae{1}.activation_function       = 'sigm';%���������
sae.ae{1}.learningRate              = 0.5;%ѧϰ��
sae.ae{1}.inputZeroMaskedFraction   = 1;%���������
opts.numepochs =   1;%ѵ����������
opts.batchsize = 50;
sae = saetrain(sae, train_x, opts);%�Ը���������������ѵ�������������������1�㡢100���ڵ㣬�����������tran_x��ÿ�ν���nnstrain��ѵ�������㶼Ϊ�������磬�����������һ��
visualize(sae.ae{1}.W{1}(:,2:end)')%�Ե�һ��Ȩֵ���п��ӻ�����һ��ȨֵW{1}���ڱ��룬�ڶ���W{2}���ڽ���

% Use the SDAE to initialize a FFNN   %��ʼ������
nn = nnsetup([8 16 14]);%�����������磬�ṹΪ[784 100 10]������ڵ�Ϊ784��������ڵ�Ϊ100�����10���ڵ�
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};%���沽�������ڱ����W{1}��������ֵb��ȨֵW������������

% Train the FFNN    %ѵ��ǰ������
opts.numepochs =   1;%����ѵ������
opts.batchsize = 10;
nn = nntrain(nn, train_x, train_y, opts);%����nntrain��ѵ���������磬��ʱ���������ʱtran_y�����Ϊ�мල��ѵ��
[er, bad] = nntest(nn, test_x, test_y);%�������
1-er    %������ȷ��
assert(er < 0.16, 'Too big error');
