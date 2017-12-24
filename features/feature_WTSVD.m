function WTSVD=feature_WTSVD(y)
% WCSVD:the SVD of the wavelet coefficients
% y:256*8
% name:the name of wavalet,such as haar,db,用单引号括起
% level:the level of the wavelet

name='db2';
level=5;
[R,C]=size(y);
WTSVD=zeros(1,C*(level+1));
for i=1:C
    [c,l]=wavedec(y(:,i),level,name);%5级小波分解，db5小波，分解级数和小波基可后期更改成合适的
    a5=appcoef(c,l,name,level);%提取低频系数，尺度为5
    d5=detcoef(c,l,5); 
    d4=detcoef(c,l,4); 
    d3=detcoef(c,l,3); 
    d2=detcoef(c,l,2); 
    d1=detcoef(c,l,1); %提取高频系数
    WTSVD(1,1+(i-1)*(level+1):(level+1)*i)=[svd(a5),svd(d5),svd(d4),svd(d3),svd(d2),svd(d1)];
end

end

