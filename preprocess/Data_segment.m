%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%���ű�ʵ��EMG�źŵķָ���Ӵ�����
%����ΪEMG�ĳ���len�����������ص�overlap������Ƶ��Ϊ2000Hz
%by zhanghuajie
%2016/11/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DataStructure=Data_segment(dataStructure,len,overlap,channelNum,sampleNum,classNum)

% len��ʾ�ָ����ݵĳ���
% overlap��ʾ�ָ�ʱ���ݵ��ص�����
% overlap=128;
% len=256;

motion_name={'wrist_extension','wrist_flexion','wrist_ulnar','wrist_radial',...
    'wrist_pronation','wrist_supination','lateral_grasp','spherical_grasp',...
    'cylinder_grasp','tripod_grasp','index','power_grasp','hand_open','relax'};


DataStructure.rawEMG=[];
DataStructure.labelID=[];
DataStructure.classname={};
for i=1:classNum %���������,14�ֶ���
    data_len=sampleNum*0.05*1926;%ÿ������5s�ڵ����ݳ���Ϊ9630=5*1926
%     j=fix(data_len/overlap-len/overlap+1);%�и��ÿ�ֶ������ݵķ���,���ڶ�������ݻ�������j=74
    j=fix((data_len-len)/(len-overlap)+1);
    tempStructure.rawEMG=zeros(channelNum,len,j);
    tempStructure.labelID=ones(j,1)*dataStructure.labelID(data_len*(i-1)+1);
    tempStructure.classname=cell(j,1);
    for k=1:j%��ÿ�ֶ��������и����
%         tempStructure.rawEMG(:,:,k)=dataStructure.rawEMG(1+(k-1)*overlap...
%             +data_len*(i-1):len+(k-1)*overlap+data_len*(i-1),:)';%һ�����ݴ����ȵ�����
        tempStructure.rawEMG(:,:,k)=dataStructure.rawEMG(1+(k-1)*(len-overlap)...
            +data_len*(i-1):len+(k-1)*(len-overlap)+data_len*(i-1),:)';
        tempStructure.classname{k,1}=motion_name{dataStructure.labelID(data_len*(i-1)+1)};
    end
    DataStructure.rawEMG=cat(3,DataStructure.rawEMG,tempStructure.rawEMG);
    DataStructure.labelID=cat(1,DataStructure.labelID,tempStructure.labelID);
    DataStructure.classname=cat(1,DataStructure.classname,tempStructure.classname);
end

end



    
