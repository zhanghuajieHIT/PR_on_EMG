% % 计算平均值和标准差
% clc;
% clear;
% address='H:\自适应方法结果\实验1,2自适应方法结果保存\14\WT_WL\验证法2，sN550,sigma25';
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
% ACC_std=std(mean_total);%应该是对每个人的均值结果求标准差，才是最后的标注差
% 
% 
% 
acc=sum(acc_total)/length(find(acc_total>0))
stdnum=std(acc_total(find(acc_total>0)))
