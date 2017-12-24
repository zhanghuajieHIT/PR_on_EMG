function MRMS=feature_MRMS(y)
% MRMS:Mean RMS
% 先对信号进行RMS处理，然后求其均值
% y:256*8

[R,C]=size(y);
MRMS=zeros(1,C);
overlap=8;
len=32;
num=fix(R/overlap-len/overlap+1);
out=zeros(num,C);
for i=1:C
    for j=1:num
       out(j,i)=sqrt((1/len)*sum(y((1+(j-1)*overlap):(len+(j-1)*overlap),i).^2)); 
    end
    MRMS(1,i)=mean(out(:,i));   
end
end
