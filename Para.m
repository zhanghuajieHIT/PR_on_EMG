function thresh=Para(y)
name='db1';
level=5;
[R,C]=size(y);
thresh=zeros(1,C);%level+1���ɷֽ���ϵ�����پ�����
for i=1:C
    [c,l]=dwt(y(:,i),name);
    yy=idwt(c,l,name,R);
    thresh(i)=max(abs(yy-y(:,i)));
    %5��С���ֽ⣬db5С�����ֽ⼶����С�����ɺ��ڸ��ĳɺ��ʵ�
%     a5=appcoef(c,l,name,level);%��ȡ��Ƶϵ�����߶�Ϊ5
%     a5=waverec(c,l,name);
%     d5=detcoef(c,l,5);
%     thresh(i)=mean(abs(d5));
%     yy=wden(y(:,i),'heursure','s','one',level,name);
%     thresh(i)=mean(abs(yy-y(:,i)));
end

end
