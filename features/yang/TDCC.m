function Feat = TDCC(S)
% S: EMG signal supposed to be Samples X Channels
% Feat: Feature matrix, supposed to be Channes X feature dimension
% Sample Entropy
% CC 5th order ARC
% RMS
%WL


[samples,channels]=size(S);

if channels>samples
    S  = S';
    [samples,channels]=size(S);
end

%S=S- repmat(mean(S),samples,1);% zero mean


for i=1:channels;
    
    tempsig  =    S(:,i);%ith channel
    
    
    feat1      =    SampEn(1,0.2*std(tempsig),tempsig);%sample entropy
    feat2     =     ARCepstrum(tempsig);%sample entropy
    feat3      =    rms( tempsig-mean(tempsig));
    feat4      =    sum( abs(diff(tempsig)))/samples;  % wavelength
    
    Feat(i,:)=[feat1 feat2 feat3 feat4];
    
end