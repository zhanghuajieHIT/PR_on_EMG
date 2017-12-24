%% main function for the pre-process of the emg data
%by zhj
%2016/11/24
%=========================================%
clc;
clear;

%需要修改的地方————————————————————
floder_path='E:\实验\Delsys数据采集\实验数据\unFilter';
len=256;
overlap=128;
channelNum=8;
sampleNum=150;
classNum=14;
%-----------------------------------------------------
%判断文件名是否已经修改
full_path = fullfile(floder_path,'*.csv');
dir_output = dir(full_path);
k = strfind(dir_output(1).name,'2017');%2017年采集的数据都写为'2017'
if k>0  %文件名未修改
    Modify_filename(floder_path);%更改文件名称
end

F_low=20;
F_high=500;
%滤波
% Data_extracted(floder_path,len,overlap,channelNum,sampleNum,classNum,F_low,F_high);
%不滤波
Data_extracted(floder_path,len,overlap,channelNum,sampleNum,classNum);

% F_low,F_high两个参数可选，如果不给定，则不进行滤波处理
% floder_path表示文件的路径（只需要到文件夹就可以了，不用文件名）
