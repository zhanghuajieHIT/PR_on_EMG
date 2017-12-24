%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%本脚本实现EMG信号的分割（即加窗处理）
%输入为EMG的长度len，即步长，重叠overlap，采样频率为2000Hz
%by zhanghuajie
%2016/11/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DataStructure=Data_segment(dataStructure,len,overlap,channelNum,sampleNum,classNum)

% len表示分割数据的长度
% overlap表示分割时数据的重叠长度
% overlap=128;
% len=256;

motion_name={'wrist_extension','wrist_flexion','wrist_ulnar','wrist_radial',...
    'wrist_pronation','wrist_supination','lateral_grasp','spherical_grasp',...
    'cylinder_grasp','tripod_grasp','index','power_grasp','hand_open','relax'};


DataStructure.rawEMG=[];
DataStructure.labelID=[];
DataStructure.classname={};
for i=1:classNum %动作类别数,14种动作
    data_len=sampleNum*0.05*1926;%每个动作5s内的数据长度为9630=5*1926
%     j=fix(data_len/overlap-len/overlap+1);%切割后每种动作数据的份数,对于多余的数据会舍弃，j=74
    j=fix((data_len-len)/(len-overlap)+1);
    tempStructure.rawEMG=zeros(channelNum,len,j);
    tempStructure.labelID=ones(j,1)*dataStructure.labelID(data_len*(i-1)+1);
    tempStructure.classname=cell(j,1);
    for k=1:j%对每种动作进行切割并命名
%         tempStructure.rawEMG(:,:,k)=dataStructure.rawEMG(1+(k-1)*overlap...
%             +data_len*(i-1):len+(k-1)*overlap+data_len*(i-1),:)';%一个数据窗长度的数据
        tempStructure.rawEMG(:,:,k)=dataStructure.rawEMG(1+(k-1)*(len-overlap)...
            +data_len*(i-1):len+(k-1)*(len-overlap)+data_len*(i-1),:)';
        tempStructure.classname{k,1}=motion_name{dataStructure.labelID(data_len*(i-1)+1)};
    end
    DataStructure.rawEMG=cat(3,DataStructure.rawEMG,tempStructure.rawEMG);
    DataStructure.labelID=cat(1,DataStructure.labelID,tempStructure.labelID);
    DataStructure.classname=cat(1,DataStructure.classname,tempStructure.classname);
end

end



    
