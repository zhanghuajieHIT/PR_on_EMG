clear;
clc;
close all;
% plot confusion matrix
% confusion matrix��ÿһ�д���һ��ķ�����Ϣ
% mat �����ÿһ�б�ʾĳһ���ݼ���Ϊѵ�����Ĳ�����ȷ�ʣ���ÿһ�еĺ�Ϊ100%
classNum=14;
file1='H:\��������\fsr20170325';
file2='H:\��������\zhj20170322';
file3='H:\��������\scy20170323';
file5='H:\��������\xsp20170327';
file6='H:\��������\zgj20170324';
file7='H:\��������\zyh20170328';
fileSet={file1,file2,file3,file5,file6,file7};%û��wrj������
total_output=zeros(classNum,classNum);
for iii=1:length(fileSet)
    funName='feature_WPT_MAV';
    FUN=funName;
    file=fileSet{iii};
    index=strfind(file,'\');
    load([file,'\������������\',file(index(end)+1:end),funName(8:end),'_CM_output.mat']);
    total_output=total_output+total_output_erevyone;
  
end
mat=total_output./(sum(total_output,2)*ones(1,size(total_output,2)))*100;
% tick={'1','2','3','4','5','6','7','8','9','10','11','12','13','14'};
tick={'WE','WF','UD','RD','WP','WS','LG','SG','CG','TP','IP','HC','HO','HR'};
draw_cm(mat,tick,classNum)%������������tick��ʾ��������
