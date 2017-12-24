function PKF=feature_PKF(y)
% y:256*8
% PKF:peak frequency

[R,C]=size(y);
PKF = zeros(1,C);
NFFT = 2^nextpow2(R);
for i = 1:C
    PKF(1,i) = max(pwelch(y(:,i),256,[],NFFT));
end

end