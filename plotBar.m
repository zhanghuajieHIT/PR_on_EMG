%%　画柱状图
clc;
clear;
close all;

x=[48.06,48.40;43.32,43.16;42.33,42.35;53.92,54.62;53.55,52.11;47.44,47.23;55.31,56.77];

bar(x);
% legend('基于时域','基于WT','基于WPT');
axis([0 8 0 60]);
% set(gca,'XTickLabel',{'MAV','MAV1','MAV2','SSI','RMS','LOG','WL','DASDV','VAR','VORDER'});
set(gca,'XTickLabel',{'TD4','RMS+AR5','TD3+AR5',['WT','_','WL'],'DFT_MAV2','TD-PSD','组合特征'});
xlabel('特征');
ylabel('识别正确率（%）');
% title('基于时域与基于时频特征效果对比');
title('')