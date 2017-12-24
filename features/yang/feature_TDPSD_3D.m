
function Feature3D = feature_TDPSD_3D(EMG, ramta)
%% Extract the TD-PSD feature of the multichanel channel EMG signal EMG
%EMG : [channels scansperchannel samples ] raw EMG data like 16*256*500
% [1] A.H. Al-Timemy, R.N. Khushaba, G. Bugmann, J. Escudero, Improving the Performance Against Force Variation of EMG Controlled Multifunctional Upper-Limb Prostheses for Transradial Amputees, IEEE Trans. Neural Syst. Rehabil. Eng., 24 (2016) 650-661.
%%
if nargin<2
    ramta=0.1;
end

FeatureSize=6;

[ChannelSize,Scans,SampleSize]=size(EMG);
Feature3D(ChannelSize,FeatureSize,SampleSize)=0;%initialize for speed

for j=1:SampleSize;% loop of sample

S     =  EMG(:,:,j);

S=S';
S=S- repmat(mean(S),Scans,1);% zero mean
S=S';

ebp  =  KSM1(S);
efp   =  KSM1(log(S.^2+eps));
    
num  = -2.*ebp.*efp;
den  = efp.*efp+ebp.*ebp;
   
Feature3D(:,:,j) = num./den;
    
end