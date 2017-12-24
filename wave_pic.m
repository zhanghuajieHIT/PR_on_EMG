%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ű�������ȡEMG�źŵĲ���ͼƬ
%lenΪ���γ��ȣ�stepΪ����
%by zhj
%2016/11/16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function wave_pic(data_file,picSaveFloder,len,step)
clc;
clear;
close all;
file='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�˲��������\SESP\a1-SESP.mat';
picSaveFloder='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\WaveformͼƬ\SESP\a1';
len=128;%64ms�ĳ���
step=64;%32ms�Ĳ�������

%% load data
data=load(file);
overlap=len-step;
data_length=length(data.EMGdata(:,1));
%% draw picture and save
num=fix((data_length/13-overlap)/(len-overlap));%�и��ÿ�ֶ������ݵķ���,���ڶ�������ݻ�����
figure('visible','off');
motion_name={'wrist_extension','wrist_flexion','wrist_ulnar','wrist_radial',...
    'wrist_pronation','wrist_supination','lateral_grasp','spherical_grasp',...
    'cylinder_grasp','tripod_grasp','index','power_grasp','hand_open'};
for i=1:13  %�������
    for j=1:num
        for k=1:8   %8ͨ��ͼ�λ���һ��ͼ����
            plot(data.EMGdata(1+(j-1)*step+data_length/13*(i-1):(j-1)*step+len+data_length/13*(i-1),k));
            hold on;
        end
        axis([0 128 -0.001 0.001]);
        axis off;
        pic=getframe(gcf);
        RGB1=imresize(pic.cdata,[256,256]);%ͼƬѹ��Ϊ256*256
        file_name=strcat(motion_name{i},'-',num2str(j),'.jpg');%����ͼƬʱ������
        if ~exist(fullfile(picSaveFloder,motion_name{i}),'file')
            mkdir(fullfile(picSaveFloder,motion_name{i}));%ÿ�����������ݱ����ڲ�ͬ���ļ�����
        end
        imwrite(RGB1,fullfile(picSaveFloder,motion_name{i},file_name),'jpg');
        hold off;
    end
end

% end
