function MHW=feature_MHW(y)
% MHW:multiple hamming windows
% y:256*8
% �д���һ��ȷ��

[R,C]=size(y);
h=hamming(R);
MHW=zeros(1,C);
for i=1:C
    signalAfterFilter=y(:,i).*h;
    MHW(1,i)=sum(signalAfterFilter.^2);
end

end

