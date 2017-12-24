function WPTE=feature_WPTE(y)
% WPCE:the energy of the wavelet packet coefficients
% С����ϵ��������ʵ������ƽ��ֵ
% �ֽ����Ƶ���źŵ�ƽ��������E=sum((Si).^2)/N������N��ʾSi�ĳ��ȣ�Si��ʾ�ֽ�����Ƶ��
% Ҳ���Գ��Բ���ƽ����������������
% y:256*8
% name:the name of wavalet packet,such as db,dmey �õ���������
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

