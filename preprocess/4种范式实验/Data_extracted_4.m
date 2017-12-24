%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Extract filtered data
% by zhanghuajie
% 2016/11/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [EMGdata]=Data_extracted_4(floder_path,new_floder_path,form_num)

% floder_path表示文件的路径（只需要到文件夹就可以了，不用文件名）
% form_num表示动作的范式数目，如果没有范式则表示某组实验重复的次数。
% form_num=4;
% floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\文件名修改后';
% new_floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\滤波后的数据';
assert(form_num~=0,'error:the number of the form must be postive integer');
full_path = fullfile(floder_path,'*-emg.csv');  %提取包括文件名的完全路径
dir_output = dir(full_path);%找出该路径下所有符合条件的文件
file_name=struct2cell(dir_output);
[~,num]=size(file_name);

% 设定数据的文件名称，格式为a1,a2。其中a到l表示共12组，1,2,3,4表示四种范式
% data_name={};
% 在函数Modify_filename中已经处理好了，下面可以不需要
% for letter_index=97:(num/4+96)    %对应字母从a到l
%     for digit_index=1:form_num
%         index=[char(letter_index),num2str(digit_index)];
%         data_name{length(data_name)+1,1}=index;
%     end 
% end

for k=1:num
    file_path=fullfile(floder_path,file_name{1,k});
    Rawdata=Analyze_csv(file_path);%原始EMG数据
    %滤波处理，20-500Hz带通，50Hz陷波
    filter=Filter_Build;%滤波器
    channelnum=8;
    motion=13;
    Data=struct();%初始化一个空的结构数组，否则在循环中会对下次的数据有影响
    for i=1:motion
        for j=1:channelnum
            data_bandpass=Filter_data(Rawdata.section{1,i}.emg(:,j+1),filter.bandpass);%带通滤波处理
            Data.section{1,i}.emg(:,j)=Filter_data(data_bandpass,filter.bandstop);%陷波滤波处理
        end
    end
            
    %13种动作的数据整合到一个数组
    %每种动作的数据长度为20000个数据点,最终的数据格式
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

%将提取的数据移动到文件夹中
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
    
