function WPTfeat=feature_WPT(y,featName,name)

if length(strfind(featName,'_'))==2%基于WT的特征，不是原始的WT特征
    index=strfind(featName,'_');
    feat=strcat(featName(1:index(1)),featName(index(2)+1:end));
else
    feat=featName;
end

if strfind(feat,'_WPT')>0
    WPTfeat=feval(feat,y);
else
    if nargin<3
        name='db3';
    end
    level=3;
    [~,C]=size(y);
    WPTfeat=[];
    for i=1:C
        T=wpdec(y(:,i),level,name);
        for j=0:2^level-1
           temp{j+1}=wpcoef(T,[level j]);
        end
        for ii=1:length(temp)
            WPTfeatTemp=feval(feat,temp{ii});
            WPTfeat=cat(2,WPTfeat,WPTfeatTemp.^(2/5));
        end
        WPTfeat=WPTfeat ./ sum(WPTfeat.^2).^ 0.5;
        
    end
end

end



