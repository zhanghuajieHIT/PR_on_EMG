function [data,label]=data_sort(data_old,label_old)
%% �����ݰ��ձ�ǩ�Ĵ�С����
index=unique(label_old);
indexNum=length(index);% indexNum=14������������
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

