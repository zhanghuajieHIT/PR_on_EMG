function WCRMS=feature_WCRMS(y)
% WCRMS:the RMS coefficient of discrete wavelet coefficients
% y:256*8
% name:the name of wavalet,such as haar,db,�õ���������
% level:the level of the wavelet
% �������ķ������ܸ�WCSVDһëһ��

name='db5';
level=5;
[R,C]=size(y);
WCRMS=zeros(1,C*(level+1));%level+1���ɷֽ���ϵ�����پ�����
for i=1:C
    [c,l]=wavedec(y(:,i),level,name);
    %5��С���ֽ⣬db5С�����ֽ⼶����С�����ɺ��ڸ��ĳɺ��ʵ�
    a5=appcoef(c,l,name,level);%��ȡ��Ƶϵ�����߶�Ϊ5
    d5=detcoef(c,l,5); %��ȡ��Ƶϵ��
    d4=detcoef(c,l,4); 
    d3=detcoef(c,l,3); 
    d2=detcoef(c,l,2); 
    d1=detcoef(c,l,1); 
    WCRMS(1,1+(i-1)*(level+1):(level+1)*i)=[rms(a5),rms(d5),...
        rms(d4),rms(d3),rms(d2),rms(d1)]; 
end


end