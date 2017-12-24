function feat=featSort(xlsFileName,experimentTime)
%计算排名前100的feature

% xlsFileName='E:\zhj20161219实验记录汇总.xlsx';
% experimentTime='组合特征';
[data,text]=xlsread(xlsFileName,experimentTime);
[a,index]=sort(data,'descend');
feat=text(index(1:20)+2,2:5);
end