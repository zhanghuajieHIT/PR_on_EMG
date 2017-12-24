function WTfeat=feature_WT(y,featName,name)
%% ����С���任��ȡ����

% ȷ������WT�任��ȡ����������
if length(strfind(featName,'_'))==2%����WT������������ԭʼ��WT����
    index=strfind(featName,'_');
    feat=strcat(featName(1:index(1)),featName(index(2)+1:end));
else
    feat=featName;
end

if strfind(feat,'_WT')>0
    WTfeat=feval(feat,y);
else
    if nargin<3
        name='db2';
    end
    level=5;
    [~,C]=size(y);
    WTfeat=[];
    for i=1:C
        [c,l]=wavedec(y(:,i),level,name);
    %5��С���ֽ⣬db5С�����ֽ⼶����С�����ɺ��ڸ��ĳɺ��ʵ�
%     a5=appcoef(c,l,name,level);%��ȡ��Ƶϵ�����߶�Ϊ5
%     d5=detcoef(c,l,5); %��ȡ��Ƶϵ��
%     d4=detcoef(c,l,4); 
%     d3=detcoef(c,l,3); 
%     d2=detcoef(c,l,2); 
%     d1=detcoef(c,l,1); 

        temp{1}=appcoef(c,l,name,level);%��ȡ��Ƶϵ�����߶�Ϊ5
        temp{2}=detcoef(c,l,5); %��ȡ��Ƶϵ��
        temp{3}=detcoef(c,l,4); 
        temp{4}=detcoef(c,l,3); 
        temp{5}=detcoef(c,l,2); 
        temp{6}=detcoef(c,l,1); 

% temp=detcoef(c,l,1); 
% WTfeatTemp=feval(feat,temp);
% WTfeat=cat(2,WTfeat,WTfeatTemp.^(2/5));

        for j=1:level+1    
            WTfeatTemp=feval(feat,temp{j});
%         WTfeat=cat(2,WTfeat,WTfeatTemp);
            WTfeat=cat(2,WTfeat,WTfeatTemp.^(2/5));
        end

    end
    WTfeat=WTfeat ./ sum(WTfeat.^2).^ 0.5;

    assert (size(WTfeat,1)==1,'DFTfeat�����ݸ�ʽ����');
end

end

