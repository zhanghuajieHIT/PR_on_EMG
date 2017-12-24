clc;
clear;

filename='H:\学习策略结果\7\IncreSVM\长期实验\WT_WL';
dir_out=dir([filename,'\*.mat']);
acc_std_saved=zeros(length(dir_out),2);%保存
for i=1:length(dir_out)
   load([filename,'\',dir_out(i).name]);
   %求均值
   acc_std_saved(i,1)=sum(acc_total)/length(find(acc_total>0))*100;
   %求标准差
    acc_std_saved(i,2)=std(acc_total(find(acc_total>0)))*100;

end

%求总的均值和所有均值的标准差
ACC_total=mean(acc_std_saved(:,1));
STD_total=std(acc_std_saved(:,1));


legend('SVM_7','LDA_7','SVM_14','LDA_14','ALDA7','ALDA14');
% 
% acc=zeros(1,19);
% dirout=dir(['H:\学习策略结果\14\ALDA\长期实验\','*.mat']);
% for i=1:length(dirout)
%    load(['H:\学习策略结果\14\ALDA\长期实验\',dirout(i).name]);
%    acc=acc+acc_total;
% end
% acc=acc/4;
% if acc(1)<1
%     acc=acc*100;
% end
% % plot(acc,'-ro');
% % plot(acc,'-.b');
% % plot(acc,'-*g');
% % plot(acc,'-<k');
% % plot(acc,'->c');
% plot(acc,'-vm');
% hold on;


timing=reshape(timing_total,size(timing_total,1)*size(timing_total,2),1);
acc=mean(timing)*1000
plot(timing)

dirout=dir(['H:\特征保存\长期实验\zhj20170508\','*.mat']);
for i=1:20
   load(['H:\特征保存\长期实验\zhj20170508\',dirout(i).name]) 
   y=real(featSaved); 
    save([num2str(i),'.mat'],'y');
    
end
