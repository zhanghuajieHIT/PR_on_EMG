%% 根据已有的特征阈值计算特征
clc;
clear;

%% 修改的地方%%%%%%%%%%%%%%%%%%
floderPath='F:\特征\zyh20170328\无归一化预处理后，overlap为128,len为256'; %数据所在文件夹
filePath='F:\特征\zyh20170328\特征保存';%阈值所在文件夹
testName='zyh20170328';%对应的受试者的名称
featN='feature_SSC';%所需要提取的特征名称
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% 加载阈值并提取特征
featNTemp=[featN,'*thresh.mat'];
dirOutThresh=dir(fullfile(filePath,featNTemp));
num=length(dirOutThresh);
for i=1:num
    trailTemp=[char(96+i),'*.mat'];
    dirOutData=dir(fullfile(floderPath,trailTemp));
    dataName=[dirOutData(1).name(1:2),dirOutData(2).name(1:2),dirOutData(3).name(1:2),dirOutData(4).name(1:2)];
    [train_data,train_label]=loadData(floderPath,dataName);
    load(fullfile(filePath,dirOutThresh(i).name));%加载阈值
    temp=strfind(dirOutThresh(i).name,'-');
    featName=dirOutThresh(i).name(1:temp(1)-1);
    saveName=[testName,'_',featName,'-',dataName,'.mat'];
    featSaved=[];
    for n=1:length(train_label)
        featSaved=cat(1,featSaved,feval(featName,train_data(:,:,n)',thresh));%提取特征
    end
    save(saveName,'featSaved');
end
b=[1,2,3 3,4,5
   1,2,4 2,3,4];
