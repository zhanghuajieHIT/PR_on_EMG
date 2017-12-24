%% 绘制柱状图的主函数
% 柱状图包括标准差
% 根据excel的数据
% 需要新建一个excel表格，专门用来放数据
clc;
clear;
close all;

%------------修改区域-----------------%
%需要绘制的数据，如‘均值’，‘标准差’
objData={'均值','标准差'};
xrange=[];%x轴的范围
yrange=[0,75];%y轴的范围
% 柱状图位置设定，需要根据经验和调试确定
% 每大组有4小组时：[-3:2:3]*0.09;
% 每大组有2小组时：[-1:2:1]*0.14;
% 只有1大组，无小组时：[1]*0.01;
% 每大组有6小组时：[-4.2:1.675:4.175]*0.08;
% 每大组有8小组时：[-3.5:1:3.5]*0.1;
picLoc=[1]*0.01;
flag=1;%flag=1，横坐标的标签设置为斜的，flag=0，不对横坐标的标签更改
%---------------------------------------%
[data,textSaved]=xlsread('bar.xlsx');
objLoc=[];
for i=1:length(objData)
    objLoc_temp=strcmp(textSaved(1,:),objData(i));
    objLoc=cat(1,objLoc,objLoc_temp);
end
[~,objCol]=find(objLoc);%找到objData的列的位置
feat_compare=textSaved(2:end,1)';
method_compare=textSaved(1,2:objCol(2)-2);

%找到均值和方差位置
[~,nanCol]=find(isnan(data(1,:)));%找到mean和std数据的分界位置
meanData=data(:,1:nanCol(1)-1);
stdData=data(:,nanCol(2)+1:end);
if size(meanData,1)==1
    bar(meanData);
else
    X=1:size(meanData,1);
    bar(X,meanData,0.8);%画出均值的柱状图
end
if ~isempty(xrange)&&~isempty(yrange)
    axis([xrange,yrange]);
elseif isempty(xrange)&&~isempty(yrange)
    ylim(yrange);
elseif isempty(yrange)&&~isempty(xrange)
    xlim(xrange);
end
hold on;
Y=[1:size(meanData,1)]'*ones(1,size(meanData,2))+ones(size(meanData,1),1)*picLoc;
errorbar(Y,meanData,stdData,'Marker','none','LineStyle','none');
legend(method_compare,'FontSize',21);
set(gca,'XTick',[1:length(meanData)],'XTickLabel',feat_compare,'FontSize',20);

if flag==1
    xtb = get(gca,'XTickLabel');   % 获取横坐标轴标签句柄
    xt = get(gca,'XTick');   % 获取横坐标轴刻度句柄
    yt = get(gca,'YTick');    % 获取纵坐标轴刻度句柄      
    xtextp=xt;    %每个标签放置位置的横坐标，这个自然应该和原来的一样了。
    % 设置显示标签的位置，写法不唯一，这里其实是在为每个标签找放置位置的纵坐标                     
    ytextp=yt(1)*ones(1,length(xt)); 
    % rotation，正的旋转角度代表逆时针旋转，旋转轴可以由HorizontalAlignment属性来设定，
    % 有3个属性值：left，right，center，这里可以改这三个值，以及rotation后的角度，这里写的是45
    % 不同的角度对应不同的旋转位置了，依自己的需求而定了。
    % ytextp - 0.5是让标签稍微下一移一点，显得不那么紧凑
    text(xtextp,ytextp-0.5,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',15); 
    set(gca,'xticklabel','');% 将原有的标签隐去
end
xlabel('特征','FontSize',22);
ylabel('识别正确率（%）','FontSize',22);
title('特征识别正确率对比','FontSize',22);

