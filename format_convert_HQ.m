%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ű����ڽ�����ʵ���е�Otto-Bock������ϳ���CNN�����õ����ݸ�ʽ
%ԭʼ���ݵĸ�ʽ��4000*8��7ͨ�����ݣ����а���һ�б�ǩ������8�ֶ�����
%ÿ�ֶ���������500����4��ԭʼ������ϳ����յ�28*28*�������ݸ�ʽ��
%���ߣ��Ż���
%ʵ���ң�HIT/DLR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [train_x,test_x,train_y,test_y]=format_convert_HQ(file1,file2,file3,file4)

%%% load data
data1=load(file1);
data2=load(file2);
data3=load(file3);
data4=load(file4);
data=[data1(:,1:7)';data2(:,1:7)';data3(:,1:7)';data4(:,1:7)'];%��ʽΪ28*4000

data_len=476;%28*17=476
motion=8;
emg_train=zeros(28,data_len*motion);
emg_test=zeros(28,data_len*motion);
for i=1:motion
    emg_train(:,data_len*(i-1)+1:data_len*i)=data(:,500*(i-1)+1:500*(i-1)+data_len);
    emg_test(:,data_len*(i-1)+1:data_len*i)=data(:,500*(i-1)+1:500*(i-1)+data_len);
end

% normalize to (0,1)
emg_train=mapminmax(emg_train,0,1);
emg_test=mapminmax(emg_test,0,1);

% EMG data from 2-D to 3-D  
train_x=zeros(28,28,136);  % ���ÿ��������200�����ݣ�8*100����Ϊһ�飬200*13=2600
test_x=zeros(28,28,136);
for i=1:136
    train_x(:,:,i)=emg_train(:,28*(i-1)+1:28*i);
    test_x(:,:,i)=emg_test(:,28*(i-1)+1:28*i);
end

% label
train_y=zeros(motion,136);
test_y=zeros(motion,136);
for i=1:motion
    train_y(i,17*(i-1)+1:17*i)=1;  
    test_y(i,17*(i-1)+1:17*i)=1;  
end
end