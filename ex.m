% % ����ƽ��ֵ�ͱ�׼��
% clc;
% clear;
% address='H:\����Ӧ�������\ʵ��1,2����Ӧ�����������\14\WT_WL\��֤��2��sN550,sigma25';
% file_path=fullfile(address,'*.mat');
% dir_out=dir(file_path);
% 
% mean_total=[];
% std_total=[];
% for i=1:length(dir_out)
%     file_name=fullfile(address,dir_out(i).name);
%     load(file_name);
%     acc_index=find(acc_total>0);
%     acc=acc_total(acc_index);
%     acc_mean=mean(acc);
%     acc_std=std(acc);
%     mean_total=cat(1,mean_total,acc_mean);
%     std_total=cat(1,std_total,acc_std);
% end
% ACC_mean=mean(mean_total);
% ACC_std=std(mean_total);%Ӧ���Ƕ�ÿ���˵ľ�ֵ������׼��������ı�ע��
% 
% 
% 
acc=sum(acc_total)/length(find(acc_total>0))
stdnum=std(acc_total(find(acc_total>0)))
