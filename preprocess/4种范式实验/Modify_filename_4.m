%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% batch modify the filename in one floder
%by zhanghuajie
%2016/11/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function Modify_filename_4(floder_path)
full_path = fullfile(floder_path,'*.csv');  %��ȡ�����������ļ�����ȫ·��
dir_output = dir(full_path);%�ҳ���·�������з����������ļ�
% file_name=struct2cell(dir_output);%���ļ�������һ�ַ�ʽ
file_num=length(dir_output);

% %% Simple version
% %����ļ����ڵ��ļ����ļ��������˳��������Ҫ��Ļ��������ü򵥰汾
% for i=1:file_num
%    file_name = dir_output(i).name;
%    new_name=strcat(num2str(i),'.mat');%���ļ�������������,�����ݲ�ͬ�ĸ�ʽ
%    movefile(file_name,new_name);
% end

%% Complex full version
new_floder_path=(fullfile(floder_path,'�ļ����޸ĺ�'));
for i=1:file_num
    j=1;
    digit_order=[];%��ʾ�ļ�����ǰ�������
   while(dir_output(i).name(j)~='-')
       digit_order=strcat(digit_order,dir_output(i).name(j));
       j=j+1;
   end
   file_name=dir_output(i).name;
   if (strfind(file_name,'SESP')>0)
       new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'1'));%20��ָ��ԭ�ļ����к��治��Ҫ���ַ��ĸ���
       new_name=strcat(new_name,'.csv');%�������ݸ�ʽ�Ķ�
       copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));%��Ӧ�ð���·����movefile�ĵ�һ������͵ڶ��������Ӧ�ð���·��
   elseif (strfind(file_name,'SEDP')>0)
       new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'2'));
       new_name=strcat(new_name,'.csv');
       copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));
   elseif (strfind(file_name,'DESP')>0)
       new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'3'));
       new_name=strcat(new_name,'.csv');
       copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));
   elseif (strfind(file_name,'DEDP')>0)
       new_name=strrep(file_name(1:length(file_name)-20),digit_order,strcat(char(96+str2num(digit_order)),'4'));
       new_name=strcat(new_name,'.csv');
       copyfile(fullfile(floder_path,file_name),fullfile(new_floder_path,new_name));
   else
       disp('The target sting can not be found ');
   end
      
end
end

