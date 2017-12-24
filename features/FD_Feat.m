function feat=FD_Feat(y)
%% 分析频域上的特征
% y:256*8

[samples,channels]=size(y);
if channels>samples
    y  = y';
    [samples,channels]=size(y);   
end
samplefre=1926;%sample frequency
fr=samplefre/samples;%frequency resolution
bands=[20 100 180 260 340 420 500];
% bands=[20 80 140 200 260 320 380 440 500];
bandindex=round(bands./fr);

feat=[];
for i=1:channels;
    tempsig  =    y(:,i);%ith channel
    dftx=abs(fft(tempsig));%dft transform, single side
    featTemp=[];
    for j=1:length(bands)-1
        bandeTemp=dftx(bandindex(j):bandindex(j+1));
        featTemp=cat(2,featTemp,sum(abs(bandeTemp)));
%         x=1:length(bandeTemp);
%         bande=polyfit(x,bandeTemp',1);
%         featTemp=cat(2,featTemp,bande(2));
%         bande(j)=mean(dftx(bandindex(j):bandindex(j+1))) ^ (2/5);
%        bande(j)=mean(dftx(bandindex(j):bandindex(j+1))) ^ (2/3);%original
    end
    
    feat=cat(2,feat,featTemp);
end
feat=feat./sum(feat.^2)^0.5;
% feat=feat ./ sum(sum(feat.^2)) ^ 0.5;%gnDFTR
% cnDFTR=gnDFTR ./ sum(gnDFTR.^2) ^ 0.5;%cnDFTR，其实没有区别

end



