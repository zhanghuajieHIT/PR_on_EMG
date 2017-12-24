function PSR=feature_PSR(y)
% y:256*8
% PSR:power spectrum ratio
% n:在最大频率处的前后各有的点数

n=32;
[R,C]=size(y);
PSR = zeros(1,C);
NFFT = 2^nextpow2(R);
for i = 1:C
    temp = pwelch(y(:,i),256,[],NFFT);
    [~,maxPoint]=max(temp);
    startPoint=maxPoint-n;
    endPoint=maxPoint+n;
    if startPoint<=0
        startPoint=1;
    end
    if endPoint>=length(temp)
        endPoint=length(temp);
    end
    rangeP=sum(temp(startPoint:endPoint));
    totalP=sum(temp);
    PSR(1,i)=rangeP/totalP;
end

end

