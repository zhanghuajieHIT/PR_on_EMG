%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Extract filtered data
% by zhanghuajie
% 2016/11/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [EMGdata]=Data_extracted_4(floder_path,new_floder_path,form_num)

% floder_path��ʾ�ļ���·����ֻ��Ҫ���ļ��оͿ����ˣ������ļ�����
% form_num��ʾ�����ķ�ʽ��Ŀ�����û�з�ʽ���ʾĳ��ʵ���ظ��Ĵ�����
% form_num=4;
% floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�ļ����޸ĺ�';
% new_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�˲��������';
assert(form_num~=0,'error:the number of the form must be postive integer');
full_path = fullfile(floder_path,'*-emg.csv');  %��ȡ�����ļ�������ȫ·��
dir_output = dir(full_path);%�ҳ���·�������з����������ļ�
file_name=struct2cell(dir_output);
[~,num]=size(file_name);

% �趨���ݵ��ļ����ƣ���ʽΪa1,a2������a��l��ʾ��12�飬1,2,3,4��ʾ���ַ�ʽ
% data_name={};
% �ں���Modify_filename���Ѿ�������ˣ�������Բ���Ҫ
% for letter_index=97:(num/4+96)    %��Ӧ��ĸ��a��l
%     for digit_index=1:form_num
%         index=[char(letter_index),num2str(digit_index)];
%         data_name{length(data_name)+1,1}=index;
%     end 
% end

for k=1:num
    file_path=fullfile(floder_path,file_name{1,k});
    Rawdata=Analyze_csv(file_path);%ԭʼEMG����
    %�˲�����20-500Hz��ͨ��50Hz�ݲ�
    filter=Filter_Build;%�˲���
    channelnum=8;
    motion=13;
    Data=struct();%��ʼ��һ���յĽṹ���飬������ѭ���л���´ε�������Ӱ��
    for i=1:motion
        for j=1:channelnum
            data_bandpass=Filter_data(Rawdata.section{1,i}.emg(:,j+1),filter.bandpass);%��ͨ�˲�����
            Data.section{1,i}.emg(:,j)=Filter_data(data_bandpass,filter.bandstop);%�ݲ��˲�����
        end
    end
            
    %13�ֶ������������ϵ�һ������
    %ÿ�ֶ��������ݳ���Ϊ20000�����ݵ�,���յ����ݸ�ʽ
    EMGdata_len=20000;
    EMGdata=zeros(260000,9);
    for i=1:motion
        EMGdata(EMGdata_len*(i-1)+1:EMGdata_len*i,1:8)=Data.section{1,i}.emg(1001:EMGdata_len+1000,:); 
        EMGdata(EMGdata_len*(i-1)+1:EMGdata_len*i,9)=i;
    end
   
%     new_floder_path=fullfile(new_floder_path,data_name{k,1});
    new_file_path=fullfile(new_floder_path,strcat(file_name{1,k}(1:7),'.mat'));
    save(new_file_path,'EMGdata');
end

%����ȡ�������ƶ����ļ�����
mkdir(fullfile(new_floder_path,'SESP'));
mkdir(fullfile(new_floder_path,'SEDP'));
mkdir(fullfile(new_floder_path,'DESP'));
mkdir(fullfile(new_floder_path,'DEDP'));
dir_output=dir(fullfile(new_floder_path,'*.mat'));

for i=1:length(dir_output)
if(strfind(dir_output(i).name,'SESP')>0)
    movefile(fullfile(new_floder_path,dir_output(i).name),fullfile(new_floder_path,'SESP',dir_output(i).name));
elseif(strfind(dir_output(i).name,'SEDP')>0)
    movefile(fullfile(new_floder_path,dir_output(i).name),fullfile(new_floder_path,'SEDP',dir_output(i).name));
elseif(strfind(dir_output(i).name,'DESP')>0)
    movefile(fullfile(new_floder_path,dir_output(i).name),fullfile(new_floder_path,'DESP',dir_output(i).name));
else
    movefile(fullfile(new_floder_path,dir_output(i).name),fullfile(new_floder_path,'DEDP',dir_output(i).name));
end

end
end
    
