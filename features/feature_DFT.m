function DFTfeat=feature_DFT(y,featName)
%% ��ȡƵ���ϵ�����
% dftx����ʾƵ������
% featName����ʾƵ������ȡ����������

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

assert (size(DFTfeat,1)==1,'DFTfeat�����ݸ�ʽ����');

end

