%%������״ͼ
clc;
clear;
close all;

x=[48.06,48.40;43.32,43.16;42.33,42.35;53.92,54.62;53.55,52.11;47.44,47.23;55.31,56.77];

bar(x);
% legend('����ʱ��','����WT','����WPT');
axis([0 8 0 60]);
% set(gca,'XTickLabel',{'MAV','MAV1','MAV2','SSI','RMS','LOG','WL','DASDV','VAR','VORDER'});
set(gca,'XTickLabel',{'TD4','RMS+AR5','TD3+AR5',['WT','_','WL'],'DFT_MAV2','TD-PSD','�������'});
xlabel('����');
ylabel('ʶ����ȷ�ʣ�%��');
% title('����ʱ�������ʱƵ����Ч���Ա�');
title('')