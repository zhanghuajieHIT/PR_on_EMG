%% �������е�������ֵ��������
clc;
clear;

%% �޸ĵĵط�%%%%%%%%%%%%%%%%%%
floderPath='F:\����\zyh20170328\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'; %���������ļ���
filePath='F:\����\zyh20170328\��������';%��ֵ�����ļ���
testName='zyh20170328';%��Ӧ�������ߵ�����
featN='feature_SSC';%����Ҫ��ȡ����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% ������ֵ����ȡ����
featNTemp=[featN,'*thresh.mat'];
dirOutThresh=dir(fullfile(filePath,featNTemp));
num=length(dirOutThresh);
for i=1:num
    trailTemp=[char(96+i),'*.mat'];
    dirOutData=dir(fullfile(floderPath,trailTemp));
    dataName=[dirOutData(1).name(1:2),dirOutData(2).name(1:2),dirOutData(3).name(1:2),dirOutData(4).name(1:2)];
    [train_data,train_label]=loadData(floderPath,dataName);
    load(fullfile(filePath,dirOutThresh(i).name));%������ֵ
    temp=strfind(dirOutThresh(i).name,'-');
    featName=dirOutThresh(i).name(1:temp(1)-1);
    saveName=[testName,'_',featName,'-',dataName,'.mat'];
    featSaved=[];
    for n=1:length(train_label)
        featSaved=cat(1,featSaved,feval(featName,train_data(:,:,n)',thresh));%��ȡ����
    end
    save(saveName,'featSaved');
end
b=[1,2,3 3,4,5
   1,2,4 2,3,4];
