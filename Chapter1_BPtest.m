clc;
clear;
close all;

%% 数据选择和归一化
%导入数据
bpdata=load ('2.dat');
%输入输出数据
input=bpdata(:,1:7);
output1=bpdata(:,8);

%设定每组输入输出信号
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

%从中随机抽取3500组数据作为训练数据，500组数据作为预测数据
k=rand(1,4000);
[m,n]=sort(k);
input_train=input(n(1:3500),:)';
output_train=output(n(1:3500),:)';
input_test=input(n(3501:4000),:)';
output_test=output(n(3501:4000),:)';

%输入数据归一化
[inputn,inputps]=mapminmax(input_train);


%% BP神经网络结构初始化
%网络结构，输入层8个节点，隐含层10个节点，输出层8个节点
innum=7;
midnum=10;
outnum=8;

%权值阈值初始化，w为权值，b为阈值
w1=rands(midnum,innum);%输入层和隐含层
b1=rands(midnum,1);%输入层和隐含层
w2=rands(midnum,outnum);%隐含层和输出层
b2=rands(outnum,1);%隐含层和输出层

w2_1=w2;w2_2=w2_1;
w1_1=w1;w1_2=w1_1;
b1_1=b1;b1_2=b1_1;
b2_1=b2;b2_2=b2_1;


%% BP神经网络训练
%学习率
xite=0.1;
alfa=0.1;

for ii=1:20
    for i=1:1:3500
         %% 网络预测输出
        x=inputn(:,i);
        for j=1:1:midnum%隐含层输出
            I(j)=inputn(:,i)'*w1(j,:)'+b1(j);
            Iout(j)=1/(1+exp(-I(j)));
        end
        yn=w2'*Iout'+b2;%输出层输出
          %% 权值阀值修正
        e=output_train(:,i)-yn;
        
        %计算权值变化率
        dw2=e*Iout;
        db2=e';
        
        for j=1:1:midnum
            S=1/(1+exp(-I(j)));
            FI(j)=S*(1-S);
        end
        for k=1:1:innum
            for j=1:1:midnum
                dw1(k,j)=FI(j)*x(k)*(e(1)*w2(j,1)+e(2)*w2(j,2)+e(3)*w2(j,3)+e(4)*w2(j,4)+e(5)*w2(j,5)+e(6)*w2(j,6)+e(7)*w2(j,7)+e(8)*w2(j,8));
                db1(j)=FI(j)*(e(1)*w2(j,1)+e(2)*w2(j,2)+e(3)*w2(j,3)+e(4)*w2(j,4)+e(5)*w2(j,5)+e(6)*w2(j,6)+e(7)*w2(j,7)+e(8)*w2(j,8));
            end
        end
        
        w1=w1_1+xite*dw1'+alfa*(w1_1-w1_2);
        b1=b1_1+xite*db1'+alfa*(b1_1-b1_2);
        w2=w2_1+xite*dw2'+alfa*(w2_1-w2_2);
        b2=b2_1+xite*db2'+alfa*(b2_1-b2_2);
        
        w1_2=w1_1;w1_1=w1;
        w2_2=w2_1;w2_1=w2;
        b1_2=b1_1;b1_1=b1;
        b2_2=b2_1;b2_1=b2;
    end
end
        
 %% BP神经网络分类
 %输入数据归一化
inputn_test=mapminmax('apply',input_test,inputps);

%网络预测
for i=1:500
    for j=1:1:midnum
        I(j)=inputn_test(:,i)'*w1(j,:)'+b1(j);
        Iout(j)=1/(1+exp(-I(j)));
    end
    fore(:,i)=w2'*Iout'+b2;
end

%类别统计
for i=1:500
    output_fore(i)=find(fore(:,i)==max(fore(:,i)));
end

for i=1:500
    switch output_fore(i)
        case 1
            output_fore(i)=1;
        case 2
            output_fore(i)=6;
        case 3
            output_fore(i)=9;
        case 4
            output_fore(i)=14;
        case 5
            output_fore(i)=17;
        case 6
            output_fore(i)=22;
        case 7
            output_fore(i)=25;
        case 8
            output_fore(i)=26;
    end
end

%预测误差
error=output_fore-output1(n(3501:4000))';

%画出预测和实际的分类图
figure(1)
plot(output_fore,'r')
hold on
plot(output1(n(3501:4000))','b')
legend('预测类别','实际类别')

%画出误差图
figure(2)
plot(error)
title('BP网络分类误差','fontsize',12)
xlabel('EMG信号','fontsize',12)
ylabel('分类误差','fontsize',12)

k=zeros(1,8);
%统计误差
for i=1:500
   if error(i)~=0
        [b,c]=max(output_test(:,i));
        switch c
        case 1
            k(1)=k(1)+1;
        case 2
            k(2)=k(2)+1;
        case 3
            k(3)=k(3)+1;
        case 4
            k(4)=k(4)+1;
        case 5
            k(5)=k(5)+1;
        case 6
            k(6)=k(6)+1;
        case 7
            k(7)=k(7)+1;
        case 8
            k(8)=k(8)+1;
       end
    end
end

kk=zeros(1,8);
for i=1:500
        [b,c]=max(output_test(:,i));
        switch c
        case 1
            kk(1)=kk(1)+1;
        case 2
            kk(2)=kk(2)+1;
        case 3
            kk(3)=kk(3)+1;
        case 4
            kk(4)=kk(4)+1;
        case 5
            kk(5)=kk(5)+1;
        case 6
            kk(6)=kk(6)+1;
        case 7
            kk(7)=kk(7)+1;
        case 8
            kk(8)=kk(8)+1;
        end
end

%统计正确率
rightridio=(kk-k)./kk