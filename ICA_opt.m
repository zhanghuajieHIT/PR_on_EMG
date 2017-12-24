function Z=ICA_opt(X)
% ICA operation
% X:256*8

% 利用的FastICA工具箱的fastica函数
% 不过目前来看没有什么效果

% 例子
load('E:\实验\Delsys数据采集\实验数据\zhj20161212\20-500Hz\无归一化无加窗\a1.mat');
data=mapminmax(dataStructure.rawEMG(:,:)',-5,5);
data=bsxfun(@minus,data,mean(data));
aa=fastica(data);


end