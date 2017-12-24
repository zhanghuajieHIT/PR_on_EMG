%% 数据调整
% 针对实验数据出现的纰漏，进行调整
function modifyData(motion,floder_path,file1,file2,classNum)
% motion表示缺少的动作，用数字表示，eg：14
% data1表示缺少动作的数据，对应的文件名为file1，eg：f1
% data2表示被复制的数据，对应的文件名为file2，eg：f2
% data2是正确完整的数据
% floder_path表示文件的位置

%% 缺少动作数-------------------------
%% 无归一化无加窗
%加载数据
% file1='f1';
% file2='f2';
% floder_path='E:\实验\Delsys数据采集\实验数据\wrj20170328';
full_path1=fullfile(floder_path,'无归一化无加窗',[file1,'.mat']);
load(full_path1);
data1=dataStructure;
full_path2=fullfile(floder_path,'无归一化无加窗',[file2,'.mat']);
load(full_path2);
data2=dataStructure;
%复制数据
motionNum=length(data2.labelID)/classNum;%每个动作的数据量
data1.rawEMG=cat(1,data1.rawEMG,data2.rawEMG((motion-1)*motionNum+1:(motion-1)*motionNum+motionNum,:));
data1.labelID=cat(1,data1.labelID,data2.labelID((motion-1)*motionNum+1:(motion-1)*motionNum+motionNum,:));
data1.datanum=data2.datanum;%两个数据一样
%保存数据
dataStructure=data1;
save([floder_path,'\无归一化无加窗\',file1],'dataStructure');

%% 无归一化有加窗
%加载数据
full_path1=fullfile(floder_path,'无归一化预处理后，overlap为128,len为256',[file1,'.mat']);
load(full_path1);
data1=DataStructure;
full_path2=fullfile(floder_path,'无归一化预处理后，overlap为128,len为256',[file2,'.mat']);
load(full_path2);
data2=DataStructure;
%复制数据
motionNum=length(data2.labelID)/classNum;%每个动作的数据量
data1.rawEMG=cat(3,data1.rawEMG,data2.rawEMG(:,:,(motion-1)*motionNum+1:(motion-1)*motionNum+motionNum));
data1.labelID=cat(1,data1.labelID,data2.labelID((motion-1)*motionNum+1:(motion-1)*motionNum+motionNum,:));
data1.classname=data2.classname;%两个数据一样
%保存数据
DataStructure=data1;
save([floder_path,'\无归一化预处理后，overlap为128,len为256\',file1],'DataStructure');
%----------------------------------------------%

end
