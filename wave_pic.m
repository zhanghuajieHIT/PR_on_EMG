%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%本脚本用于提取EMG信号的波形图片
%len为波形长度，step为步长
%by zhj
%2016/11/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function wave_pic(data_file,picSaveFloder,len,step)
clc;
clear;
close all;
file='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\滤波后的数据\SESP\a1-SESP.mat';
picSaveFloder='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\Waveform图片\SESP\a1';
len=128;%64ms的长度
step=64;%32ms的步进长度

%% load data
data=load(file);
overlap=len-step;
data_length=length(data.EMGdata(:,1));
%% draw picture and save
num=fix((data_length/13-overlap)/(len-overlap));%切割后每种动作数据的份数,对于多余的数据会舍弃
figure('visible','off');
motion_name={'wrist_extension','wrist_flexion','wrist_ulnar','wrist_radial',...
    'wrist_pronation','wrist_supination','lateral_grasp','spherical_grasp',...
    'cylinder_grasp','tripod_grasp','index','power_grasp','hand_open'};
for i=1:13  %动作类别
    for j=1:num
        for k=1:8   %8通道图形画在一个图像上
            plot(data.EMGdata(1+(j-1)*step+data_length/13*(i-1):(j-1)*step+len+data_length/13*(i-1),k));
            hold on;
        end
        axis([0 128 -0.001 0.001]);
        axis off;
        pic=getframe(gcf);
        RGB1=imresize(pic.cdata,[256,256]);%图片压缩为256*256
        file_name=strcat(motion_name{i},'-',num2str(j),'.jpg');%保存图片时的名称
        if ~exist(fullfile(picSaveFloder,motion_name{i}),'file')
            mkdir(fullfile(picSaveFloder,motion_name{i}));%每个动作的数据保存在不同的文件夹中
        end
        imwrite(RGB1,fullfile(picSaveFloder,motion_name{i},file_name),'jpg');
        hold off;
    end
end

% end
