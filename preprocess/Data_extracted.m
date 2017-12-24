%% Extract filtered data
% by zhanghuajie
% 2016/11/11
%%
function Data_extracted(floder_path,len,overlap,channelNum,sampleNum,classNum,F_low,F_high)
% floder_path表示文件的路径（只需要到文件夹就可以了，不用文件名）

% DataStructure=cell(1,24);%有24组实验

full_path = fullfile(floder_path,'*-emg.csv');  %提取包括文件名的完全路径
dir_output = dir(full_path);%找出该路径下所有符合条件的文件
file_name=struct2cell(dir_output);
[~,num]=size(file_name);

for k=1:num
    file_path=fullfile(floder_path,file_name{1,k});
    data=Analyze_csv(file_path,channelNum,sampleNum);%原始EMG数据
    
    %% 先不做归一化处理,无加窗
    tempDataStructure.rawEMG=[];
    tempDataStructure.labelID=[];
    tempDataStructure.datanum=zeros(length(data.section),1);
    for i=1:length(data.section)
        tempDataStructure.datanum(i,1)=length(data.section{1,i}.emg);
        tempDataStructure.rawEMG=cat(1,tempDataStructure.rawEMG,data.section{1,i}.emg);
        tempDataStructure.labelID=cat(1,tempDataStructure.labelID,...
            ones(tempDataStructure.datanum(i,1),1)*data.section{1,i}.labelID);
    end
%     dataStructure.rawEMG=mapminmax(tempDataStructure.rawEMG',-1,1);%归一化处理  
    dataStructure.rawEMG=tempDataStructure.rawEMG;
    dataStructure.labelID=tempDataStructure.labelID;
    dataStructure.datanum=tempDataStructure.datanum;
    %% 滤波处理
    if nargin==8
        dataStructure.rawEMG=filterMain(dataStructure.rawEMG,F_low,F_high,channelNum);
    end
    %% 保存无加窗数据
    new_floder_path=(fullfile(floder_path,'无归一化无加窗'));
    if ~exist(new_floder_path,'file')
        mkdir(new_floder_path);
    end
    new_file_path=fullfile(new_floder_path,strcat(file_name{1,k}(1:2),'.mat'));
    save(new_file_path,'dataStructure');

         
%% 把数据剪切为固定的长度
    %14种动作的数据整合到一个数组
    %每种动作的数据长度为10000个数据点,最终的数据格式
%     EMGdata_len=10000;
%     EMGdata=zeros(140000,9);
%     for i=1:14
%         EMGdata(EMGdata_len*(i-1)+1:EMGdata_len*i,1:8)=data.section{1,i}.emg(1001:EMGdata_len+1000,:); 
%         EMGdata(EMGdata_len*(i-1)+1:EMGdata_len*i,9)=i;
%     end
   
    %% 数据不剪切为固定长度
%     EMGdata=[];
%     for i=1:14
%         EMGdata=[EMGdata;data.section{1,i}.emg,ones(size(data.section{1,i}.emg,1),1)*data.section{1,i}.labelID];  
%     end
    
    %% 数据分割
    DataStructure=Data_segment(dataStructure,len,overlap,channelNum,sampleNum,classNum);
    
    %% 数据保存
    new_floder_path=(fullfile(floder_path,['无归一化预处理后，overlap为',num2str(overlap),',len为',num2str(len)]));
    if ~exist(new_floder_path,'file')
        mkdir(new_floder_path);
    end
%     new_floder_path=fullfile(new_floder_path,data_name{k,1});
    new_file_path=fullfile(new_floder_path,strcat(file_name{1,k}(1:2),'.mat'));
    save(new_file_path,'DataStructure');
end

end
    
