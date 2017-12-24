function VAR=feature_VAR(y)
% VAR:variance of EMG
% y:256*8

[R,C]=size(y);
VAR=zeros(1,C);
for i=1:C
    VAR(1,i)=(1/(R-1))*sum(y(:,i).^2);
end

end