function gnDFTR=feature_gnDFTR(y)
% y：256*8
% 论文：
% Invariant Surface EMG Feature Against Varying Contraction Level for Myoelectric Control Based on Muscle Coordination

[samples,channels]=size(y);

if channels>samples
    y  = y';
    [samples,channels]=size(y);
    
end

%y  =   y - repmat(mean(y),samples,1);% zero mean

samplefre=1926;%sample frequency
fr=samplefre/samples;%frequency resolution
bands=[20 100 180 260 340 420 500];
% bands=[20 80 140 200 260 320 380 440 500];
bandindex=round(bands./fr);

gnDFTR=[];
for i=1:channels;
    
    tempsig  =    y(:,i);%ith channel

   dftx       =abs(fft(tempsig));%dft transform, single side
   
   % 这种方法较好，不用事先给定特征的列数
   for j=1:length(bands)-1
       bande(j)=mean(dftx(bandindex(j):bandindex(j+1))) ^ (2/5);
%        bande(j)=mean(dftx(bandindex(j):bandindex(j+1))) ^ (2/3);%original
   end
  gnDFTR=cat(2,gnDFTR,bande);

end

gnDFTR=gnDFTR ./ sum(sum(gnDFTR.^2)) ^ 0.5;%gnDFTR
% cnDFTR=gnDFTR ./ sum(gnDFTR.^2) ^ 0.5;%cnDFTR，其实没有区别

end
