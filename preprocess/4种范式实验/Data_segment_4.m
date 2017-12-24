%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%本脚本实现EMG信号的分割（即加窗处理）
%有两个版本，分别为分片数据直接保存到某个文件夹；分片数据保存在一个变量中,此时函数需要有返回值。
%版本一能对一个文件夹内的所有数据分片
%版本二只能对文件夹内的一组数据分片，因此调用版本二时需要循环处理
%输入为EMG的长度len，即步长，重叠overlap，采样频率为2000Hz
%by zhanghuajie
%2016/11/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% version one:分片数据直接保存到某个文件夹
% function Data_segment_4(len,overlap,paradigm,segmentData_floder_path,data_floder_path)

% segmentData_floder_path表示分割后数据的保存文件夹路径
% data_floder_path表示需要分割的数据文件夹路径
% len表示分割数据的长度
% overlap表示分割时数据的重叠长度
% segmentData_floder_path='E:\实验\Delsys数据采集\实验数据\分割后的数据';
% data_floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\滤波后的数据';
% len=100;
% overlap=50;
% paradigm表示实验的范式，如'SESP','DEDP'等。或者表示实验的重复次数，如'NO.1'，'NO.2'等

motion_name={'wrist_extension','wrist_flexion','wrist_ulnar','wrist_radial',...
    'wrist_pronation','wrist_supination','lateral_grasp','spherical_grasp',...
    'cylinder_grasp','tripod_grasp','index','power_grasp','hand_open'};

full_path=fullfile(data_floder_path,'*.mat');
dir_output=dir(full_path); %在文件夹中搜索以.mat为后缀的文件并记录

folder_name=strcat(num2str(len),'-',num2str(overlap)); %记录步长并创建以步长命名的文件夹
segmentData_floder_path=fullfile(segmentData_floder_path,folder_name,paradigm);%将字符串连接在一起
mkdir(segmentData_floder_path);%新建文件夹

for i=1:length(dir_output)%读取.mat后缀文件的数目
    data_with_label=load(fullfile(data_floder_path,dir_output(i).name));%数据格式为（数据点数，9）
    data=data_with_label.EMGdata(:,1:8);
    j=fix((length(data(:,1))/13-overlap)/(len-overlap));%切割后每种动作数据的份数,对于多余的数据会舍弃
    for motion=1:13
        motion_floder_path=fullfile(segmentData_floder_path,motion_name{motion});%每个动作文件夹的路径
        if ~exist(motion_floder_path,'file')
            mkdir(motion_floder_path);%每个动作的数据保存在不同的文件夹中
        end
       for k=1:j%对每种动作进行切割并命名
           data_slice=data(((k-1)*len-(k-1)*overlap+1+(motion-1)*(length(data(:,1))/13)):(k*len-(k-1)*overlap+(motion-1)*(length(data(:,1))/13)),:);
           %((k-1)*len-(k-1)*overlap+1表示在每个动作数据内时，每一个分段数据的起点
           %k*len-(k-1)*overlap表示在每个动作数据内时，每一个分段数据的终点
           %(motion-1)*(length(data(:,1))/14)表示不同动作的数据起点
           file_name=strcat(dir_output(i).name(1:length(dir_output(i).name)-4),'-',motion_name(motion),'-',num2str(k),'.mat');
           save (fullfile(motion_floder_path,file_name{1,1}),'data_slice');
       end
    end
end
end

%%% version two:分片数据保存在一个变量中,此时函数需要有返回值
% function [data_slice_total]=Data_segment(len,overlap,data_file_path)
% % data_file_path是指文件路径，包括文件格式。在调用此函数时，可以使用dir和fullfile函数找到路径
% 
% data_with_label=load(data_file_path);%数据格式为（数据点数，9）
% data=data_with_label.EMGdata(:,1:8);
% j=fix((length(data(:,1))/13-overlap)/(len-overlap));%切割后每种动作数据的份数,对于多余的数据会舍弃
% for motion=1:13
%     data_slice_total=[];
%     for k=1:j%对每种动作进行切割并命名
%         data_slice=data(((k-1)*len-(k-1)*overlap+(motion-1)*(length(data(:,1))/13)+1):(k*len-(k-1)*overlap+(motion-1)*(length(data(:,1))/13)+1),:);
%         data_slice_total=[data_slice_total;data_slice];
%     end  
% end
% end


    
