clc;
clear;

filename='H:\ѧϰ���Խ��\7\IncreSVM\����ʵ��\WT_WL';
dir_out=dir([filename,'\*.mat']);
acc_std_saved=zeros(length(dir_out),2);%����
for i=1:length(dir_out)
   load([filename,'\',dir_out(i).name]);
   %���ֵ
   acc_std_saved(i,1)=sum(acc_total)/length(find(acc_total>0))*100;
   %���׼��
    acc_std_saved(i,2)=std(acc_total(find(acc_total>0)))*100;

end

%���ܵľ�ֵ�����о�ֵ�ı�׼��
ACC_total=mean(acc_std_saved(:,1));
STD_total=std(acc_std_saved(:,1));


legend('SVM_7','LDA_7','SVM_14','LDA_14','ALDA7','ALDA14');
% 
% acc=zeros(1,19);
% dirout=dir(['H:\ѧϰ���Խ��\14\ALDA\����ʵ��\','*.mat']);
% for i=1:length(dirout)
%    load(['H:\ѧϰ���Խ��\14\ALDA\����ʵ��\',dirout(i).name]);
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

dirout=dir(['H:\��������\����ʵ��\zhj20170508\','*.mat']);
for i=1:20
   load(['H:\��������\����ʵ��\zhj20170508\',dirout(i).name]) 
   y=real(featSaved); 
    save([num2str(i),'.mat'],'y');
    
end
