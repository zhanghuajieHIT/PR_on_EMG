function WTM=feature_WTM(y)
% WCM:the max coefficient of discrete wavelet coefficients
% y:256*8
% name:the name of wavalet,such as haar,db,用单引号括起
% level:the level of the wavelet

name='db2';
level=5;
[R,C]=size(y);
WTM=zeros(1,C*(level+1));%level+1是由分解后的系数多少决定的
for i=1:C
    [c,l]=wavedec(y(:,i),level,name);
    %5级小波分解，db5小波，分解级数和小波基可后期更改成合适的
    a5=appcoef(c,l,name,level);%提取低频系数，尺度为5
    d5=detcoef(c,l,5); %提取高频系数
    d4=detcoef(c,l,4); 
    d3=detcoef(c,l,3); 
    d2=detcoef(c,l,2); 
    d1=detcoef(c,l,1); 
    WTM(1,1+(i-1)*(level+1):(level+1)*i)=[max(abs(a5)),max(abs(d5)),...
        max(abs(d4)),max(abs(d3)),max(abs(d2)),max(abs(d1))]; 
end

end

