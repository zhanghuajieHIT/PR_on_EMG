function MNF=feature_MNF(y)
%MNF:mean frequency
%y:emg signal,256*8
%Sampling frequency:2000Hz

%% ��ʽ��
[R, C] = size(y);
MNF = zeros(1,C);
Fs = 1926; % Sampling frequency
L = R; % Number of samples
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT);
for i = 1:C  %��ÿ��ͨ�����
    P = abs(fft(y(:,i),NFFT).^2/L);%������
    MNF(1,i) = sum(P.*f') / sum(P);
%     MNF(1,i)=10*log10(MNF(1,i));%������ʽ
end

% %% ����ͼ��
% [R, C] = size(y);
% MNF = zeros(1,C);
% Fs = 2000; % Sampling frequency
% L = R; % Number of samples
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% window=boxcar(length(L));
% for i = 1:C  %��ÿ��ͨ�����
%     [P,f]=periodogram(y(:,i),window,NFFT,Fs);
%     MNF(1,i) = sum(P.*f') / sum(P);
% % %     MNF(1,i)=10*log10(MNF(1,i));%������ʽ
% end


% %% �Ӵ���
% [R,C] = size(y);
% MNF = zeros(1,C);
% for i = 1:C
%     [Pxx, W] = pwelch(y(:,i));
%     MNF(1,i) = (sum(W.*Pxx))/(sum(Pxx));
% end

end