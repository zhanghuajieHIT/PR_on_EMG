%% main function for the pre-process of the emg data
%by zhj
%2016/11/24
%=========================================%
clc;
clear;

%��Ҫ�޸ĵĵط�����������������������������������������
floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\unFilter';
len=256;
overlap=128;
channelNum=8;
sampleNum=150;
classNum=14;
%-----------------------------------------------------
%�ж��ļ����Ƿ��Ѿ��޸�
full_path = fullfile(floder_path,'*.csv');
dir_output = dir(full_path);
k = strfind(dir_output(1).name,'2017');%2017��ɼ������ݶ�дΪ'2017'
if k>0  %�ļ���δ�޸�
    Modify_filename(floder_path);%�����ļ�����
end

F_low=20;
F_high=500;
%�˲�
% Data_extracted(floder_path,len,overlap,channelNum,sampleNum,classNum,F_low,F_high);
%���˲�
Data_extracted(floder_path,len,overlap,channelNum,sampleNum,classNum);

% F_low,F_high����������ѡ��������������򲻽����˲�����
% floder_path��ʾ�ļ���·����ֻ��Ҫ���ļ��оͿ����ˣ������ļ�����
