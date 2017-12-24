function RConv1=feature_RConv1(y)
% RConv:单通道信号卷积后取均方根
% y:256*8
% 一个卷积核对整个通道内的信号进行卷积

[R,C]=size(y);
RConv1=zeros(1,C);
% h=y(:,1);%卷积核1
h=ones(10,1);%卷积核2
for i=1:C
    RConv1(1,i)=rms(conv(y(:,i),h));
end

end
