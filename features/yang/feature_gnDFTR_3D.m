
function Feature3D = feature_gnDFTR_3D(EMG)
%% Extract the TD-PSD feature of the multichanel channel EMG signal EMG
%EMG : [channels scansperchannel samples ] raw EMG data like 16*256*500



FeatureSize=6;

[ChannelSize,Scans,SampleSize]=size(EMG);
Feature3D(ChannelSize,FeatureSize,SampleSize)=0;%initialize for speed

for j=1:SampleSize;% loop of sample

S     =  EMG(:,:,j);

S=S';
S=S- repmat(mean(S),Scans,1);% zero mean
S=S';

   
Feature3D(:,:,j) = gnDFTR(S);
    
end