function RConv1=feature_RConv1(y)
% RConv:��ͨ���źž����ȡ������
% y:256*8
% һ������˶�����ͨ���ڵ��źŽ��о��

[R,C]=size(y);
RConv1=zeros(1,C);
% h=y(:,1);%�����1
h=ones(10,1);%�����2
for i=1:C
    RConv1(1,i)=rms(conv(y(:,i),h));
end

end
