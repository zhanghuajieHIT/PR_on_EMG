function Feat = RMSAR5(S)
% S: EMG signal supposed to be Samples X Channels
% Feat: Feature matrix, supposed to be Channes X feature dimension
% RMS
% AR 5 order

[samples,channels]=size(S);

if channels>samples
    S  = S';
    [samples,channels]=size(S);
end

S=S- repmat(mean(S),samples,1);% zero mean
Feat=[];
for i=1:channels;
    
    tempsig  =    S(:,i);%ith channel
    feat1      =    rms(tempsig);
    feat2      =    arburg( tempsig,5);
    
   FeatTemp=[feat1,feat2(2:6)];
   Feat=cat(2,Feat,FeatTemp);
   
end

% Reference
% M. A. Oskoei and H. Hu, ¡°Myoelectric control systems¡ªA survey," Biomed. Signal Process. Control, vol. 2, no. 4, pp. 275¨C294, 2007