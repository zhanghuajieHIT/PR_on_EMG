function FR = feature_FR( y )
% FR:Frequency Ratio
% Returns the ratio of the lowest frequency in a channel to the highest
% frequency in the channel

[R, C] = size(y);
FR = zeros(1,C);
L = R; % Number of samples
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
for i = 1:C
    Fy = abs(fft(y(:,i),NFFT)/L);
    FR(1,i) = min(Fy)/max(Fy);
end

end

