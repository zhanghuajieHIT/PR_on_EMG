function DFTfeat=feature_DFT(y,featName)
%% 提取频域上的特征
% dftx：表示频域数据
% featName：表示频域上提取的特征名称

dftx=DFT(y);

NUM=length(dftx);
DFTfeat=[];
if length(strfind(featName,'_'))==2
    index=strfind(featName,'_');
    feat=strcat(featName(1:index(1)),featName(index(2)+1:end));
else
    feat=featName;
end
for i=1:NUM
    DFTfeatTemp=feval(feat,dftx{i});
%     DFTfeat=cat(2,DFTfeat,DFTfeatTemp);
    DFTfeat=cat(2,DFTfeat,DFTfeatTemp.^(2/5));
end
DFTfeat=DFTfeat ./ sum(DFTfeat.^2) ^ 0.5;

assert (size(DFTfeat,1)==1,'DFTfeat的数据格式有误');

end

