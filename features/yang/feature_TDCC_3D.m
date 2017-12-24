function Feature3D = feature_TDCC_3D(EMG)
%% Extract the RMSAR5 feature of the multichanel channel EMG signal EMG
%EMG : [channels scansperchannel samples ] raw EMG data like 16*256*500
% [1] A. Phinyomark, F. Quaine, S. Charbonnier, C. Serviere, F. Tarpin-Bernard, Y. Laurillau, EMG feature evaluation for improving myoelectric pattern recognition robustness, Expert Systems with Applications, 40 (2013) 4832-4840.

FeatureSize=8;%

[ChannelSize,Scans,SampleSize]=size(EMG);
Feature3D(ChannelSize,FeatureSize,SampleSize)=0;%initialize for speed

for j=1:SampleSize;% loop of sample

S    = EMG(:,:,j);

S=S';
S=S- repmat(mean(S),Scans,1);% zero mean
S=S';

tdcc=TDCC(S);
   
Feature3D(:,:,j) = tdcc;
    
end



% Reference
% A. Phinyomark, F. Quaine, S. Charbonnier, C. Serviere, F. Tarpin-Bernard, Y. Laurillau, EMG feature evaluation for improving myoelectric pattern recognition robustness, Expert Systems with Applications, 40 (2013) 4832-4840.
