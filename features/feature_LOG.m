function LOG=feature_LOG(y)
% LOG:log detector
% y:256*8

[R,C]=size(y);
LOG=zeros(1,C);
for i=1:C
   LOG(1,i)=exp((1/R)*sum(log(abs(y(:,i)))));
end

end