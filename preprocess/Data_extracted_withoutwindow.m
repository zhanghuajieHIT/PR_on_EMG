%% �����ؽ��ź���ȡ���������Ӵ�����
%��14�ֶ������ӵ�һ��������
% by zhj
% 2016/11/28
%========================%
%%
function Data_extracted_withoutwindow(floder_path)


full_path = fullfile(floder_path,'*-emg.csv');  %��ȡ�����ļ�������ȫ·��
dir_output = dir(full_path);%�ҳ���·�������з����������ļ�
file_name=struct2cell(dir_output);
[~,num]=size(file_name);

new_floder_path=(fullfile(floder_path,'��ȡ�ź��޼Ӵ�'));
if ~exist(new_floder_path,'file')
    mkdir(new_floder_path);
end


for k=1:num
    file_path=fullfile(floder_path,file_name{1,k});
    data=Analyze_csv(file_path);%ԭʼEMG����
    %����������
    DataStructure.rawEMG=[];
    DataStructure.labelID=[];
    for i=1:length(data.section)
        DataStructure.rawEMG=cat(1,DataStructure.rawEMG,data.section{1,i}.emg);
        DataStructure.labelID=cat(1,DataStructure.labelID,ones(length(data.section{1,i}.emg),1)*data.section{1,i}.labelID);
    end
    new_file_path=fullfile(new_floder_path,strcat(file_name{1,k}(1:2),'.mat'));
    save(new_file_path,'DataStructure');
end

end