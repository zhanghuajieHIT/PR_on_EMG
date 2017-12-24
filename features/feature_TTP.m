function TTP=feature_TTP(y)
% y:256*8
% TTP:total power

[R,C] = size(y);
TTP = zeros(1,C);
NFFT = 2^nextpow2(R);
for i = 1:C
    TTP(1,i) = sum(pwelch(y(:,i),256,[],NFFT));
end