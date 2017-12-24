function Feat=gnDFTR(S)

% S: EMG signal supposed to be Samples X Channels
% Feat: Feature matrix, supposed to be Channes X feature dimension

[samples,channels]=size(S);

if channels>samples
    S  = S';
    [samples,channels]=size(S);
    
end

%S  =   S - repmat(mean(S),samples,1);% zero mean

samplefre=1000;%sample frequency
fr=samplefre/samples;%frequency resolution
bands=[20 92 163 235 307 378 450];%bands
bandindex=round(bands./fr);

Feat=[];
for i=1:channels;
    
    tempsig  =    S(:,i);%ith channel

   dftx       =2*abs(fft(tempsig));%dft transform, single side
   
   for j=1:6;
       bande(j)=mean(dftx(bandindex(j):bandindex(j+1))) ^ (2/3);
       
   end
  Feat(i,:)  = bande;
end

Feat=Feat ./ sum(sum(Feat.^2)) ^ 0.5;%


