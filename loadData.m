function [data,label]=loadData(floderPath,dataName)
% load data
% floderPath:文件夹路径
% dataName:文件名称

% 判断输入的格式是否正确
dataNum=length(dataName)/2;
if dataNum>1
    assert(rem(dataNum,1)==0,'文件名称有错，请重新输入。');
end
for i=2:2:length(dataName)
    assert(~isnan(str2double(dataName(i))),'文件名称有错，请重新输入。');
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
