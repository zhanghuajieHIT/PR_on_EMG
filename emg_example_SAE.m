% function [result,local]=emg_example_SAE(file)
clear;
clc;
close all;
%��������
%% Delsys_data
% file='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�˲��������\SESP\a1-SESP.mat';
% data=load(file);
% 
% train_x=zeros(200000,8);
% train_y=zeros(200000,13);
% for i=1:200000%ѵ������������
%     rowID=randi(260000);
%     train_x(i,:)=data.EMGdata(rowID,1:8);
%     train_y(i,data.EMGdata(rowID,9))=1;
% end
% 
% test_x=zeros(20000,8);
% test_y=zeros(20000,13);
% for i=1:20000
%     rowID=randi(260000);
%     test_x(i,:)=data.EMGdata(rowID,1:8);
%     test_y(i,data.EMGdata(rowID,9))=1;
% end

%% HQ_data
file='E:\ʵ��\����ʦ��ʵ��\ʵ������\20160319\5-2.dat';
emg=load(file);
%�����������
input=emg(:,1:7);
output1=emg(:,8);

%�趨ÿ����������ź�
output=zeros(4000,8);
for i=1:4000
    switch output1(i)
        case 1
            output(i,:)=[1 0 0 0 0 0 0 0];
        case 6
            output(i,:)=[0 1 0 0 0 0 0 0];
        case 9
            output(i,:)=[0 0 1 0 0 0 0 0];
        case 14
            output(i,:)=[0 0 0 1 0 0 0 0];
        case 17
            output(i,:)=[0 0 0 0 1 0 0 0];
        case 22
            output(i,:)=[0 0 0 0 0 1 0 0];
        case 25
            output(i,:)=[0 0 0 0 0 0 1 0];
        case 26
            output(i,:)=[0 0 0 0 0 0 0 1];
    end
end

%���������ȡ3500��������Ϊѵ�����ݣ�500��������ΪԤ������
rand('state',0);
k=rand(1,4000);
[m,n]=sort(k);
%yΪ��ǩ
train_x=input(n(1:3500),:);
train_y=output(n(1:3500),:);
test_x=input(n(3501:4000),:);
test_y=output(n(3501:4000),:);

%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)

minnum=1;
maxnum=50;
rightrate=zeros(maxnum-minnum,1);
for hiddensize=minnum:maxnum    %������ڵ���

% hiddensize=50;
rand('state',0)
sae = saesetup([7 hiddensize]);%HQ_data
% sae = saesetup([8 hiddensize]);%Delsys_data
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.learningRate              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
opts.numepochs =   1;
opts.batchsize = 10;
sae = saetrain(sae, train_x, opts);
% visualize(sae.ae{1}.W{1}(:,2:end)')%by ZHJ

% Use the SDAE to initialize a FFNN
nn = nnsetup([7 hiddensize 8]);%HQ_data
% nn = nnsetup([8 hiddensize 13]);%Delsys_data
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
opts.numepochs =   1;
opts.batchsize = 10;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
rightrate(hiddensize)=1-er;    %by ZHJ
%assert(er < 0.16, 'Too big error');

end
%by ZHJ
 plot(rightrate);
 xlabel('������ڵ���');
 ylabel('��ȷ��');
[result,local]=max(rightrate);

% display(['resutlt= ',num2str(result),'.']);
% display(['hiddensize= ',num2str(local),'.']);
% end
