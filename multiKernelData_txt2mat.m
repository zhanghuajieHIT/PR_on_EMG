function [data,dataTemp] = multiKernelData_txt2mat(filename)
% 先要确定txt中的特征有多少种，然后根据情况在“输出数据及对应特征和核函数”中修改
dataTemp=importfile(filename);
nanRow=isnan(dataTemp(:,1));
dataTemp(nanRow,:)=[];

%% 输出数据及对应特征和核函数
data.a.rbf_rq_expk=dataTemp(1:12,:);
data.a.rbfExtend=dataTemp(13:24,:);
data.a.rbfMultiscale=dataTemp(25:36,:);

data.b.rbf_rq_expk=dataTemp(37:48,:);
data.b.rbfExtend=dataTemp(49:60,:);
data.b.rbfMultiscale=dataTemp(61:72,:);

data.c.rbf_rq_expk=dataTemp(73:82,:);
data.c.rbfExtend=dataTemp(82:96,:);
data.c.rbfMultiscale=dataTemp(97:108,:);

data.d.rbf_rq_expk=dataTemp(109:120,:);
data.d.rbfExtend=dataTemp(121:132,:);
data.d.rbfMultiscale=dataTemp(133:144,:);

data.e.rbf_rq_expk=dataTemp(145:156,:);
data.e.rbfExtend=dataTemp(157:168,:);
data.e.rbfMultiscale=dataTemp(169:180,:);

data.f.rbf_rq_expk=dataTemp(181:192,:);
data.f.rbfExtend=dataTemp(193:204,:);
data.f.rbfMultiscale=dataTemp(205:216,:);

% data.g.rbf_rq_expk=dataTemp(217:228,:);
% data.g.rbfExtend=dataTemp(229:240,:);
% data.g.rbfMultiscale=dataTemp(241:252,:);

end




