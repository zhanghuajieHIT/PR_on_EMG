%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% batch modify the filename in one floder
%by zhanghuajie
%2016/11/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Modify_filename(floder_path)
full_path = fullfile(floder_path,'*.csv');  %提取符合条件的文件的完全路径
% new_floder_path=(fullfile(floder_path,'文件名修改后'));
% if ~exist(new_floder_path,'file')
%     mkdir(new_floder_path);
% end
dir_output = dir(full_path);%找出该路径下所有符合条件的文件
% file_name=struct2cell(dir_output);%求文件名的另一种方式
file_num=length(dir_output);

%% Simple version
%如果文件夹内的文件以文件名排序的顺序是满足要求的话，可以用简单版本
for i=1:file_num
   file_name = dir_output(i).name;
   new_name=file_name(1:length(file_name)-20);%20是指在原文件名中后面不需要的字符的个数
   new_name=strcat(new_name,'.csv');%根据数据格式改动
   movefile(fullfile(floder_path,file_name),fullfile(floder_path,new_name));%还应该包含路径，movefile的第一项参数和第二项参数都应该包含路径
   % 保险起见，实验数据都必须要保存两份
end

%% Complex full version
% for i=1:file_num
%     j=1;
%     digit_order=[];%表示文件名最前面的数字
%    while(dir_output(i).name(j)~='-')
%        digit_order=strcat(digit_order,dir_output(i).name(j));
%        j=j+1;
%    end
%    file_name=dir_output(i).name;
%    if (strfind(file_name,'SESP')>0)
%        new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'1'));%20是指在原文件名中后面不需要的字符的个数
%        new_name=strcat(new_name,'.csv');%根据数据格式改动
%        copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));%还应该包含路径，movefile的第一项参数和第二项参数都应该包含路径
%    elseif (strfind(file_name,'SEDP')>0)
%        new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'2'));
%        new_name=strcat(new_name,'.csv');
%        copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));
%    elseif (strfind(file_name,'DESP')>0)
%        new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'3'));
%        new_name=strcat(new_name,'.csv');
%        copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));
%    elseif (strfind(file_name,'DEDP')>0)
%        new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'4'));
%        new_name=strcat(new_name,'.csv');
%        copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));
%    else
%        disp('The target sting can not be found ');
%    end
%       
% end
end

