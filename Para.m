function thresh=Para(y)
name='db1';
level=5;
[R,C]=size(y);
thresh=zeros(1,C);%level+1是由分解后的系数多少决定的
for i=1:C
    [c,l]=dwt(y(:,i),name);
    yy=idwt(c,l,name,R);
    thresh(i)=max(abs(yy-y(:,i)));
    %5级小波分解，db5小波，分解级数和小波基可后期更改成合适的
%     a5=appcoef(c,l,name,level);%提取低频系数，尺度为5
%     a5=waverec(c,l,name);
%     d5=detcoef(c,l,5);
%     thresh(i)=mean(abs(d5));
%     yy=wden(y(:,i),'heursure','s','one',level,name);
%     thresh(i)=mean(abs(yy-y(:,i)));
end

end
