function MTW=feature_MTW(y)
% MTW:multiple trapezoidal windows
% y:256*8
% 有待进一步确认

[R,C]=size(y);
h=hamming(R);
MTW=zeros(1,C);
for i=1:C
    MTW(1,i)=sum((y(:,i).^2).*h);
end  
    
end

