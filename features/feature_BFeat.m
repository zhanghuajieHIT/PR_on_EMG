function BFeat=feature_BFeat(y,featName)
%% 时域特征的改进
% y:原始分段信号，256*8

if length(strfind(featName,'_'))==2
    index=strfind(featName,'_');
    feat=strcat(featName(1:index(1)),featName(index(2)+1:end));
else
    feat=featName;
end

BFeat=feval(feat,y);
BFeat=BFeat./sum(BFeat.^2).^ 0.5;
end

