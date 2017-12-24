%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%���ű�ʵ��EMG�źŵķָ���Ӵ�����
%�������汾���ֱ�Ϊ��Ƭ����ֱ�ӱ��浽ĳ���ļ��У���Ƭ���ݱ�����һ��������,��ʱ������Ҫ�з���ֵ��
%�汾һ�ܶ�һ���ļ����ڵ��������ݷ�Ƭ
%�汾��ֻ�ܶ��ļ����ڵ�һ�����ݷ�Ƭ����˵��ð汾��ʱ��Ҫѭ������
%����ΪEMG�ĳ���len�����������ص�overlap������Ƶ��Ϊ2000Hz
%by zhanghuajie
%2016/11/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% version one:��Ƭ����ֱ�ӱ��浽ĳ���ļ���
% function Data_segment_4(len,overlap,paradigm,segmentData_floder_path,data_floder_path)

% segmentData_floder_path��ʾ�ָ�����ݵı����ļ���·��
% data_floder_path��ʾ��Ҫ�ָ�������ļ���·��
% len��ʾ�ָ����ݵĳ���
% overlap��ʾ�ָ�ʱ���ݵ��ص�����
% segmentData_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\�ָ�������';
% data_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�˲��������';
% len=100;
% overlap=50;
% paradigm��ʾʵ��ķ�ʽ����'SESP','DEDP'�ȡ����߱�ʾʵ����ظ���������'NO.1'��'NO.2'��

motion_name={'wrist_extension','wrist_flexion','wrist_ulnar','wrist_radial',...
    'wrist_pronation','wrist_supination','lateral_grasp','spherical_grasp',...
    'cylinder_grasp','tripod_grasp','index','power_grasp','hand_open'};

full_path=fullfile(data_floder_path,'*.mat');
dir_output=dir(full_path); %���ļ�����������.matΪ��׺���ļ�����¼

folder_name=strcat(num2str(len),'-',num2str(overlap)); %��¼�����������Բ����������ļ���
segmentData_floder_path=fullfile(segmentData_floder_path,folder_name,paradigm);%���ַ���������һ��
mkdir(segmentData_floder_path);%�½��ļ���

for i=1:length(dir_output)%��ȡ.mat��׺�ļ�����Ŀ
    data_with_label=load(fullfile(data_floder_path,dir_output(i).name));%���ݸ�ʽΪ�����ݵ�����9��
    data=data_with_label.EMGdata(:,1:8);
    j=fix((length(data(:,1))/13-overlap)/(len-overlap));%�и��ÿ�ֶ������ݵķ���,���ڶ�������ݻ�����
    for motion=1:13
        motion_floder_path=fullfile(segmentData_floder_path,motion_name{motion});%ÿ�������ļ��е�·��
        if ~exist(motion_floder_path,'file')
            mkdir(motion_floder_path);%ÿ�����������ݱ����ڲ�ͬ���ļ�����
        end
       for k=1:j%��ÿ�ֶ��������и����
           data_slice=data(((k-1)*len-(k-1)*overlap+1+(motion-1)*(length(data(:,1))/13)):(k*len-(k-1)*overlap+(motion-1)*(length(data(:,1))/13)),:);
           %((k-1)*len-(k-1)*overlap+1��ʾ��ÿ������������ʱ��ÿһ���ֶ����ݵ����
           %k*len-(k-1)*overlap��ʾ��ÿ������������ʱ��ÿһ���ֶ����ݵ��յ�
           %(motion-1)*(length(data(:,1))/14)��ʾ��ͬ�������������
           file_name=strcat(dir_output(i).name(1:length(dir_output(i).name)-4),'-',motion_name(motion),'-',num2str(k),'.mat');
           save (fullfile(motion_floder_path,file_name{1,1}),'data_slice');
       end
    end
end
end

%%% version two:��Ƭ���ݱ�����һ��������,��ʱ������Ҫ�з���ֵ
% function [data_slice_total]=Data_segment(len,overlap,data_file_path)
% % data_file_path��ָ�ļ�·���������ļ���ʽ���ڵ��ô˺���ʱ������ʹ��dir��fullfile�����ҵ�·��
% 
% data_with_label=load(data_file_path);%���ݸ�ʽΪ�����ݵ�����9��
% data=data_with_label.EMGdata(:,1:8);
% j=fix((length(data(:,1))/13-overlap)/(len-overlap));%�и��ÿ�ֶ������ݵķ���,���ڶ�������ݻ�����
% for motion=1:13
%     data_slice_total=[];
%     for k=1:j%��ÿ�ֶ��������и����
%         data_slice=data(((k-1)*len-(k-1)*overlap+(motion-1)*(length(data(:,1))/13)+1):(k*len-(k-1)*overlap+(motion-1)*(length(data(:,1))/13)+1),:);
%         data_slice_total=[data_slice_total;data_slice];
%     end  
% end
% end


    
