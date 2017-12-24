%%%%%%%%%%%%
clear;
file{24}={};
for i=1:24
    file{i}=['E:\实验\黄琦师兄实验\实验数据\20160310\',num2str(i),'.dat'];
end
train_data_x=zeros(28,28,816);
test_data_x=zeros(28,28,816);
[train_x,test_x,train_y,test_y]=format_convert_HQ(file{1},file{2},file{3},file{4});
train_data_x(:,:,1:136)=train_x;
test_data_x(:,:,1:136)=test_x;
train_data_y=train_y;
test_data_y=test_y;
[train_x,test_x,train_y,test_y]=format_convert_HQ(file{5},file{6},file{7},file{8});
train_data_x(:,:,136+1:136*2)=train_x;
test_data_x(:,:,136+1:136*2)=test_x;
train_data_y=[train_data_y,train_y];
test_data_y=[test_data_y,test_y];
[train_x,test_x,train_y,test_y]=format_convert_HQ(file{9},file{10},file{11},file{12});
train_data_x(:,:,136*2+1:136*3)=train_x;
test_data_x(:,:,136*2+1:136*3)=test_x;
train_data_y=[train_data_y,train_y];
test_data_y=[test_data_y,test_y];
[train_x,test_x,train_y,test_y]=format_convert_HQ(file{13},file{14},file{15},file{16});
train_data_x(:,:,136*3+1:136*4)=train_x;
test_data_x(:,:,136*3+1:136*4)=test_x;
train_data_y=[train_data_y,train_y];
test_data_y=[test_data_y,test_y];
[train_x,test_x,train_y,test_y]=format_convert_HQ(file{17},file{18},file{19},file{20});
train_data_x(:,:,136*4+1:136*5)=train_x;
test_data_x(:,:,136*4+1:136*5)=test_x;
train_data_y=[train_data_y,train_y];
test_data_y=[test_data_y,test_y];
[train_x,test_x,train_y,test_y]=format_convert_HQ(file{21},file{22},file{23},file{24});
train_data_x(:,:,136*5+1:136*6)=train_x;
test_data_x(:,:,136*5+1:136*6)=test_x;
train_data_y=[train_data_y,train_y];
test_data_y=[test_data_y,test_y];

%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11.30% error. 
%With 100 epochs you'll get around 1.2% error

rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer outputmaps: numbers of filters
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer 
    struct('type', 's', 'scale', 2) %subsampling layer
%     struct('type', 'c', 'outputmaps', 120, 'kernelsize', 5) %0.0388
%     struct('type', 's', 'scale', 2) %subsampling layer
};


opts.alpha = 1;
opts.batchsize = 48;
opts.numepochs = 1;
opts.stepsize = 8;
cnn.activation = 'Sigmoid'; % now we have Relu and Sigmoid activation functions
cnn.pooling_mode = 'Mean'; %now we have Mean and Max pooling
cnn.output = 'Softmax';% noe we have Softmax and Sigmoid output function
opts.iteration = 1;
cnn = cnnsetup(cnn, train_data_x, train_data_y);
for i = 1 : opts.iteration
    cnn = cnntrain(cnn, train_data_x, train_data_y, opts);
    [er, bad] = cnntest(cnn, test_data_x, test_data_y);
    fprintf('%d iterations and rate of error : %d\n',i,er);
    %[er1, bad1] = cnntest(cnn, val_x, val_Label);
    %fprintf('%d iterations and rate of error (validation) : %d\n',i,er1);
    if mod(i,opts.stepsize) == 0
        opts.alpha = opts.alpha/10;%change learning rate
    end
end
%[er, bad] = cnntest(cnn, test_x, test_y);
fprintf('Taux of error : %d\n',er(i));
%plot mean squared error
figure; plot(cnn.rL);
assert(er<0.12, 'Too big error');
