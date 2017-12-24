function RConv2=feature_RConv2(y)
% RConv:��ͨ���źž����ȡ������
% y:256*8
% �ȶ�����ͨ���ڵ��źŽ��зָȻ���ÿ���ֶ��þ���˾��

[R,C]=size(y);
RConv2=zeros(1,C);
h=ones(20,1);
len=20;
for i=1:C
    temp=[];
    for j=1:fix(R/len)
        temp=cat(1,temp,conv(y(len*(j-1)+1:len*j,i),h));        
    end
    RConv2(1,i)=rms(temp);
end

end

