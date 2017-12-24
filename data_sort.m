function [data,label]=data_sort(data_old,label_old)
%% 将数据按照标签的大小排列
index=unique(label_old);
indexNum=length(index);% indexNum=14，动作种类数
dataTemp=[];
labelTemp=[];
for i=1:indexNum
    [row,~]=find(label_old==index(i));
    dataTemp=cat(1,dataTemp,data_old(row,:));
    labelTemp=cat(1,labelTemp,label_old(row));
end
data=dataTemp;
label=labelTemp;

end

