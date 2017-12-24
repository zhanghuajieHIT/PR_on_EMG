function drawSpectrum(y)
% draw the spectrum of the signal y with fft
% y is the 1-D signal

fs=1926;%采样频率
len=length(y);
N=2.^nextpow2(len);%fft的数据长度,这个长度一般要大于y的点数，在fft是不足的点会自动补零。
Y=abs(fft(y(:,1),N));
n=1:N;
X=n*fs/N;
plot(X(1:N/2),Y(1:N/2));

end
