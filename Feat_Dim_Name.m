function fun=Feat_Dim_Name(featName)
% calculate the dimension of feature (the column number of the feature) 
% calculate the name of the select feature function

featSpecies=length(featName);%组合的特征数目
fun=cell(1,featSpecies);
for i=1:featSpecies
    fun{i}.name=featName{i};
    if strcmp(fun{i}.name,'feature_WCE')||strcmp(fun{i}.name,'feature_WCM')||strcmp(fun{i}.name,'feature_WCSVD')||strcmp(fun{i}.name,'feature_gnDFTR')
        fun{i}.featCol=48; 
    elseif strcmp(fun{i}.name,'feature_WPCE')||strcmp(fun{i}.name,'feature_WPCM')||strcmp(fun{i}.name,'feature_WPCSVD')
        fun{i}.featCol=64;
    elseif strcmp(fun{i}.name,'feature_HIST')
        fun{i}.featCol=72;
    elseif strcmp(fun{i}.name,'feature_AR')||strcmp(fun{i}.name,'feature_CC')
        fun{i}.featCol=40;
    elseif strcmp(fun{i}.name,'feature_MAVS')
        fun{i}.featCol=7;
    elseif strcmp(fun{i}.name,'feature_DRMS')
        fun{i}.featCol=15;
    elseif strcmp(fun{i}.name,'feature_DRMS2')
        fun{i}.featCol=16;
    else
        fun{i}.featCol=8;%特征的列数
    end
end



end