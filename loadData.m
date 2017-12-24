function [data,label]=loadData(floderPath,dataName)
% load data
% floderPath:�ļ���·��
% dataName:�ļ�����

% �ж�����ĸ�ʽ�Ƿ���ȷ
dataNum=length(dataName)/2;
if dataNum>1
    assert(rem(dataNum,1)==0,'�ļ������д����������롣');
end
for i=2:2:length(dataName)
    assert(~isnan(str2double(dataName(i))),'�ļ������д����������롣');
end

data=[];
label=[];
for i=1:2:length(dataName)
filePath = fullfile(floderPath,strcat(dataName(i:i+1),'.mat'));
load(filePath);
data=cat(3,data,DataStructure.rawEMG);
label=cat(1,label,DataStructure.labelID);
end

end
