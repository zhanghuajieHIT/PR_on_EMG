function BFeat=feature_BFeat(y,featName)
%% ʱ�������ĸĽ�
% y:ԭʼ�ֶ��źţ�256*8

if length(strfind(featName,'_'))==2
    index=strfind(featName,'_');
    feat=strcat(featName(1:index(1)),featName(index(2)+1:end));
else
    feat=featName;
end

BFeat=feval(feat,y);
BFeat=BFeat./sum(BFeat.^2).^ 0.5;
end

