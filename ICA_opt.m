function Z=ICA_opt(X)
% ICA operation
% X:256*8

% ���õ�FastICA�������fastica����
% ����Ŀǰ����û��ʲôЧ��

% ����
load('E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161212\20-500Hz\�޹�һ���޼Ӵ�\a1.mat');
data=mapminmax(dataStructure.rawEMG(:,:)',-5,5);
data=bsxfun(@minus,data,mean(data));
aa=fastica(data);


end