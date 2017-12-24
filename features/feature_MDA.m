function MFMD = feature_MDA( y )
% Returns the median amplitude spectrum in each bin calculated from fft
% ÖÐ¼ä·ùÖµÆ×
% y:256*8

[R, C] = size(y);
MFMD = zeros(1,C);

L = R; % Number of samples
NFFT = 2^nextpow2(L); % Next power of 2 from length of y

for i = 1:C
    MFMD(1,i) = (1/2)*sum(abs(fft(y(:,i),NFFT)/L));
end

end

