function dftx=DFT(y)
%% 进行离散傅里叶变换

[samples,channels]=size(y);
if channels>samples
    y  = y';
    [samples,channels]=size(y);
end
samplefre=1926;%sample frequency
fr=samplefre/samples;%frequency resolution
bands=[20 100 180 260 340 420 500];
bandindex=round(bands./fr);
dftx={};
for i=1:channels;
    tempsig  =    y(:,i);%ith channel
    dftxTemp =abs(fft(tempsig));%dft transform, single side
    for j=1:length(bands)-1
        bande{j}=dftxTemp(bandindex(j):bandindex(j+1));
    end
    dftx=cat(2,dftx,bande);%1行*(分段数*通道数)列
    
end
% dftx=dftx';
end
