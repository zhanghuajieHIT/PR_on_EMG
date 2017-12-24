function MDF=feature_MDF(y)
%MNF:median frequency
%y:emg signal,256*8
%Sampling frequency:2000Hz

%% ��ʽ��
[R, C] = size(y);
MDF = zeros(1,C);
Fs = 1926; % Sampling frequency
L = R; % Number of samples
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
for i = 1:C  %��ÿ��ͨ�����
    MDF(1,i) = (1/2)*sum(abs(fft(y(:,i),NFFT).^2/L));
%     MDF(1,i)=10*log10(MDF(1,i));
end

% %% ����ͼ��
% [R, C] = size(y);
% MDF = zeros(1,C);
% Fs = 2000; % Sampling frequency
% L = R; % Number of samples
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% window=boxcar(length(L));
% for i = 1:C  %��ÿ��ͨ�����
%     [P,~]=periodogram(y(:,i),window,NFFT,Fs);
%     MDF(1,i)=(1/2)*sum(P);
% %     MDF(1,i)=10*log10(MNF(1,i));%������ʽ
% end

%���ܿ���Щ
% %% �Ӵ���
% [R,C] = size(y);
% NFFT = 2^nextpow2(R);
% MDF = zeros(1,C);
% for i = 1:C
%     MDF(1,i) = (1/2)*sum(pwelch(y(:,i),256,[],NFFT));
% end


end