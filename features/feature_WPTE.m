function WPTE=feature_WPTE(y)
% WPCE:the energy of the wavelet packet coefficients
% 小波包系数能量其实就是其平方值
% 分解后子频段信号的平均能量：E=sum((Si).^2)/N，其中N表示Si的长度，Si表示分解后的子频段
% 也可以尝试不用平均能量，用总能量
% y:256*8
% name:the name of wavalet packet,such as db,dmey 用单引号括起
% level:the level of wavelet packet decompose

level=3;
name='db2';
[R,C]=size(y);
WPTE=zeros(1,(2^level)*C);
for i=1:C
    T=wpdec(y(:,i),level,name);
    E = wenergy(T);
    WPTE(1,1+(i-1)*(2^level):(2^level)*i)=E;
end

