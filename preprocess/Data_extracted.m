%% Extract filtered data
% by zhanghuajie
% 2016/11/11
%%
function Data_extracted(floder_path,len,overlap,channelNum,sampleNum,classNum,F_low,F_high)
% floder_path��ʾ�ļ���·����ֻ��Ҫ���ļ��оͿ����ˣ������ļ�����

% DataStructure=cell(1,24);%��24��ʵ��

full_path = fullfile(floder_path,'*-emg.csv');  %��ȡ�����ļ�������ȫ·��
dir_output = dir(full_path);%�ҳ���·�������з����������ļ�
file_name=struct2cell(dir_output);
[~,num]=size(file_name);

for k=1:num
    file_path=fullfile(floder_path,file_name{1,k});
    data=Analyze_csv(file_path,channelNum,sampleNum);%ԭʼEMG����
    
    %% �Ȳ�����һ������,�޼Ӵ�
    tempDataStructure.rawEMG=[];
    tempDataStructure.labelID=[];
    tempDataStructure.datanum=zeros(length(data.section),1);
    for i=1:length(data.section)
        tempDataStructure.datanum(i,1)=length(data.section{1,i}.emg);
        tempDataStructure.rawEMG=cat(1,tempDataStructure.rawEMG,data.section{1,i}.emg);
        tempDataStructure.labelID=cat(1,tempDataStructure.labelID,...
            ones(tempDataStructure.datanum(i,1),1)*data.section{1,i}.labelID);
    end
%     dataStructure.rawEMG=mapminmax(tempDataStructure.rawEMG',-1,1);%��һ������  
    dataStructure.rawEMG=tempDataStructure.rawEMG;
    dataStructure.labelID=tempDataStructure.labelID;
    dataStructure.datanum=tempDataStructure.datanum;
    %% �˲�����
    if nargin==8
        dataStructure.rawEMG=filterMain(dataStructure.rawEMG,F_low,F_high,channelNum);
    end
    %% �����޼Ӵ�����
    new_floder_path=(fullfile(floder_path,'�޹�һ���޼Ӵ�'));
    if ~exist(new_floder_path,'file')
        mkdir(new_floder_path);
    end
    new_file_path=fullfile(new_floder_path,strcat(file_name{1,k}(1:2),'.mat'));
    save(new_file_path,'dataStructure');

         
%% �����ݼ���Ϊ�̶��ĳ���
    %14�ֶ������������ϵ�һ������
    %ÿ�ֶ��������ݳ���Ϊ10000�����ݵ�,���յ����ݸ�ʽ
%     EMGdata_len=10000;
%     EMGdata=zeros(140000,9);
%     for i=1:14
%         EMGdata(EMGdata_len*(i-1)+1:EMGdata_len*i,1:8)=data.section{1,i}.emg(1001:EMGdata_len+1000,:); 
%         EMGdata(EMGdata_len*(i-1)+1:EMGdata_len*i,9)=i;
%     end
   
    %% ���ݲ�����Ϊ�̶�����
%     EMGdata=[];
%     for i=1:14
%         EMGdata=[EMGdata;data.section{1,i}.emg,ones(size(data.section{1,i}.emg,1),1)*data.section{1,i}.labelID];  
%     end
    
    %% ���ݷָ�
    DataStructure=Data_segment(dataStructure,len,overlap,channelNum,sampleNum,classNum);
    
    %% ���ݱ���
    new_floder_path=(fullfile(floder_path,['�޹�һ��Ԥ�����overlapΪ',num2str(overlap),',lenΪ',num2str(len)]));
    if ~exist(new_floder_path,'file')
        mkdir(new_floder_path);
    end
%     new_floder_path=fullfile(new_floder_path,data_name{k,1});
    new_file_path=fullfile(new_floder_path,strcat(file_name{1,k}(1:2),'.mat'));
    save(new_file_path,'DataStructure');
end

end
    
