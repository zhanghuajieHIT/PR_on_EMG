function MNP=feature_MNP(y)
% y:256*8
% MNP:mean power

[R,C]=size(y);
NFFT = 2^nextpow2(R);
MNP = zeros(1,C);
for i = 1:C
    MNP(1,i) = sum((pwelch(y(:,i),256,[],NFFT))/R);
end




end