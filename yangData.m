%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ű����ڶ�����ʦ�����ݽ���SDAE����
%���ݵĸ�ʽ��8*256���Ѿ������ݽ��мӴ�
%���ݴ���ƫ�ƣ���Ҫ�����ݽ���ȥ��ֵ����
%by zhj
%2016/11/17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function yangData(file)
file='E:\ʵ��\����ʦ����\EMG data.mat';
load(file);

%% ȥ��ֵ,��ֵԼΪ1.2
for i=1:length(DataStructure)%i��1��9
    DataStructure{1,i}.rawEMG=DataStructure{1,i}.rawEMG-1.2;
end

%% ȷ����������
% [~,~,num]=size(DataStructure{1,i}.rawEMG);%numΪrawEMG�����ݵ�����
[~,~,num]=size(DataStructure{1,1}.rawEMG);
train_x=zeros(2048,2000);
train_y=zeros(2000,7);%7�ֶ���
for i=1:2000%ѵ������������
    rowID=randi(num);
    train_x(:,i)=reshape(DataStructure{1,1}.rawEMG(:,:,rowID),2048,1);%8*256�������ʽ
    train_y(i,DataStructure{1,1}.labelID(rowID))=1;
end
train_x=train_x';

test_x=zeros(2048,num-2000);
test_y=zeros(num-2000,7);
for i=1:num-2000
    rowID=randi(num);
    test_x(:,i)=reshape(DataStructure{1,1}.rawEMG(:,:,rowID),2048,1);
    test_y(i,DataStructure{1,1}.labelID(rowID))=1;
end
test_x=test_x';

%% ex
rng(0);
sae = saesetup([2048 100]);
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.learningRate              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
opts.numepochs =   1;
opts.batchsize = 100;
sae = saetrain(sae, train_x, opts);
% visualize(sae.ae{1}.W{1}(:,2:end)')

% Use the SDAE to initialize a FFNN
nn = nnsetup([2048 100 7]);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
opts.numepochs =   1;
opts.batchsize = 100;
[nn,L,loss] = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.16, 'Too big error');

% end