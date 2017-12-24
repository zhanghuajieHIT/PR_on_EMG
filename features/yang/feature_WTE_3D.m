function Feature3D = feature_WTE_3D(EMG)
%% Extract the RMSAR5 feature of the multichanel channel EMG signal EMG
%EMG : [channels scansperchannel samples ] raw EMG data like 16*256*500
% M. A. Oskoei and H. Hu, ¡°Myoelectric control systems¡ªA survey," Biomed. Signal Process. Control, vol. 2, no. 4, pp. 275¨C294, 2007


FeatureSize=6;% ea(1)+ed(2)

[ChannelSize,Scans,SampleSize]=size(EMG);
Feature3D(ChannelSize,FeatureSize,SampleSize)=0;%initialize for speed

for j=1:SampleSize;% loop of sample

S    = EMG(:,:,j);

S=S';
S=S- repmat(mean(S),Scans,1);% zero mean
S=S';

rmsar=WTE(S);
   
Feature3D(:,:,j) = rmsar;
    
end



% Reference
% M. A. Oskoei and H. Hu, ¡°Myoelectric control systems¡ªA survey," Biomed. Signal Process. Control, vol. 2, no. 4, pp. 275¨C294, 2007
