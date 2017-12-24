function MTW=feature_MTW(y)
% MTW:multiple trapezoidal windows
% y:256*8
% �д���һ��ȷ��

[R,C]=size(y);
h=hamming(R);
MTW=zeros(1,C);
for i=1:C
    MTW(1,i)=sum((y(:,i).^2).*h);
end  
    
end

