clear;
clc;
close all;
% plot confusion matrix
% confusion matrix的每一行代表一类的分类信息
% mat 矩阵的每一行表示某一数据集作为训练集的测试正确率，即每一行的和为100%
classNum=14;
file1='H:\特征保存\fsr20170325';
file2='H:\特征保存\zhj20170322';
file3='H:\特征保存\scy20170323';
file5='H:\特征保存\xsp20170327';
file6='H:\特征保存\zgj20170324';
file7='H:\特征保存\zyh20170328';
fileSet={file1,file2,file3,file5,file6,file7};%没有wrj的数据
total_output=zeros(classNum,classNum);
for iii=1:length(fileSet)
    funName='feature_WPT_MAV';
    FUN=funName;
    file=fileSet{iii};
    index=strfind(file,'\');
    load([file,'\混淆矩阵数据\',file(index(end)+1:end),funName(8:end),'_CM_output.mat']);
    total_output=total_output+total_output_erevyone;
  
end
mat=total_output./(sum(total_output,2)*ones(1,size(total_output,2)))*100;
% tick={'1','2','3','4','5','6','7','8','9','10','11','12','13','14'};
tick={'WE','WF','UD','RD','WP','WS','LG','SG','CG','TP','IP','HC','HO','HR'};
draw_cm(mat,tick,classNum)%画出混淆矩阵，tick表示种类名称
