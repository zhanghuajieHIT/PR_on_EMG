function feat=featSort(xlsFileName,experimentTime)
%��������ǰ100��feature

% xlsFileName='E:\zhj20161219ʵ���¼����.xlsx';
% experimentTime='�������';
[data,text]=xlsread(xlsFileName,experimentTime);
[a,index]=sort(data,'descend');
feat=text(index(1:20)+2,2:5);
end