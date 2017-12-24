function MFMN = feature_MFMN( y )
% Returns the mean amplitude spectrum in each bin calculated by FFT
% 平均幅值谱

[R, C] = size(y);
MFMN = zeros(1,C);
Fs = 1926; % Sampling frequency
L = R; % Number of samples
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT);
for i = 1:C
    P = abs(fft(y(:,i),NFFT)/L);%功率谱
    MFMN(1,i) = sum(P.*f') / sum(P);
end

end
