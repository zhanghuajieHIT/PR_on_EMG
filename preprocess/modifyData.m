%% ���ݵ���
% ���ʵ�����ݳ��ֵ��©�����е���
function modifyData(motion,floder_path,file1,file2,classNum)
% motion��ʾȱ�ٵĶ����������ֱ�ʾ��eg��14
% data1��ʾȱ�ٶ��������ݣ���Ӧ���ļ���Ϊfile1��eg��f1
% data2��ʾ�����Ƶ����ݣ���Ӧ���ļ���Ϊfile2��eg��f2
% data2����ȷ����������
% floder_path��ʾ�ļ���λ��

%% ȱ�ٶ�����-------------------------
%% �޹�һ���޼Ӵ�
%��������
% file1='f1';
% file2='f2';
% floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\wrj20170328';
full_path1=fullfile(floder_path,'�޹�һ���޼Ӵ�',[file1,'.mat']);
load(full_path1);
data1=dataStructure;
full_path2=fullfile(floder_path,'�޹�һ���޼Ӵ�',[file2,'.mat']);
load(full_path2);
data2=dataStructure;
%��������
motionNum=length(data2.labelID)/classNum;%ÿ��������������
data1.rawEMG=cat(1,data1.rawEMG,data2.rawEMG((motion-1)*motionNum+1:(motion-1)*motionNum+motionNum,:));
data1.labelID=cat(1,data1.labelID,data2.labelID((motion-1)*motionNum+1:(motion-1)*motionNum+motionNum,:));
data1.datanum=data2.datanum;%��������һ��
%��������
dataStructure=data1;
save([floder_path,'\�޹�һ���޼Ӵ�\',file1],'dataStructure');

%% �޹�һ���мӴ�
%��������
full_path1=fullfile(floder_path,'�޹�һ��Ԥ�����overlapΪ128,lenΪ256',[file1,'.mat']);
load(full_path1);
data1=DataStructure;
full_path2=fullfile(floder_path,'�޹�һ��Ԥ�����overlapΪ128,lenΪ256',[file2,'.mat']);
load(full_path2);
data2=DataStructure;
%��������
motionNum=length(data2.labelID)/classNum;%ÿ��������������
data1.rawEMG=cat(3,data1.rawEMG,data2.rawEMG(:,:,(motion-1)*motionNum+1:(motion-1)*motionNum+motionNum));
data1.labelID=cat(1,data1.labelID,data2.labelID((motion-1)*motionNum+1:(motion-1)*motionNum+motionNum,:));
data1.classname=data2.classname;%��������һ��
%��������
DataStructure=data1;
save([floder_path,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256\',file1],'DataStructure');
%----------------------------------------------%

end
