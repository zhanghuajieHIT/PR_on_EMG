function WTM=feature_WTM(y)
% WCM:the max coefficient of discrete wavelet coefficients
% y:256*8
% name:the name of wavalet,such as haar,db,�õ���������
% level:the level of the wavelet

name='db2';
level=5;
[R,C]=size(y);
WTM=zeros(1,C*(level+1));%level+1���ɷֽ���ϵ�����پ�����
for i=1:C
    [c,l]=wavedec(y(:,i),level,name);
    %5��С���ֽ⣬db5С�����ֽ⼶����С�����ɺ��ڸ��ĳɺ��ʵ�
    a5=appcoef(c,l,name,level);%��ȡ��Ƶϵ�����߶�Ϊ5
    d5=detcoef(c,l,5); %��ȡ��Ƶϵ��
    d4=detcoef(c,l,4); 
    d3=detcoef(c,l,3); 
    d2=detcoef(c,l,2); 
    d1=detcoef(c,l,1); 
    WTM(1,1+(i-1)*(level+1):(level+1)*i)=[max(abs(a5)),max(abs(d5)),...
        max(abs(d4)),max(abs(d3)),max(abs(d2)),max(abs(d1))]; 
end

end

