function drawSpectrum(y)
% draw the spectrum of the signal y with fft
% y is the 1-D signal

fs=1926;%����Ƶ��
len=length(y);
N=2.^nextpow2(len);%fft�����ݳ���,�������һ��Ҫ����y�ĵ�������fft�ǲ���ĵ���Զ����㡣
Y=abs(fft(y(:,1),N));
n=1:N;
X=n*fs/N;
plot(X(1:N/2),Y(1:N/2));

end
