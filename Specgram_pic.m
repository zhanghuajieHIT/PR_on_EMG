%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������ʵ��EMG�źŵ�STFTͼ�����ɣ���������ָ�����ļ�����
%ÿ��ͨ�����ж�Ӧ��STFTͼ�Σ���󱣴����8ͨ��ͼ��RGB��ƽ��ֵ
%by zhanghuajie
%2016/11/13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function Specgram_pic(pic_floder_path,data_floder_path)

% pic_floder_path��ָͼƬ������ļ���
% data_floder_path��ָ��Ҫת��ΪͼƬ���������ڵ��ļ���

% clc;
% clear;
% pic_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\SpecgramͼƬ\SESP\cylinder_grasp';
% data_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�ָ�������\100-50\SESP\cylinder_grasp';
% 
% dir_output=dir(fullfile(data_floder_path,'*.mat'));
% k=length(dir_output);%ͳ���ļ�����Ŀ
% R=1024;%���ô���������
% window=hamming(R);%ʹ�ú�����
% N=1024;%��ʱ����Ҷ��������
% L=512;%����
% overlap=R-L;%���ص�����
% for i=1:k
% file_name = dir_output(i).name;%��¼.mat �ļ�����
% % [x,fs]=auread(dir_output(i).name);%��ȡ.au �ļ�
% data=load(fullfile(data_floder_path,dir_output(i).name));
% figure('visible','off');
% % x= awgn(x,100,'measured','linear');%�����˸�˹������
% % x= x(1:3.2:end,1); %����Ҫ�������ֲ������øú���
% 
% for j=1:8
%     [pic,f,t]=specgram(data(:,j),N,2000,window,overlap);%��������ͼ
%     %y=20*log10(abs(s)+eps);%����Ҫ��ת��ʵ��������
%     %[y,PS] = mapminmax(y,0,1);%����Ҫ��һ����[0�� 1]����
%     %[y,PS] = mapminmax(y,-1,1);%����Ҫ��һ����[-1�� 1]����
%     %y = y*255;%��һ������ת��������ͼ����
%     %y=uint8(y);%��һ������ת��������ͼ����
%     axis off;%�ر�����
%     imagesc(y)%�Ѿ�����Ƴ�ͼʱ���� 
%     colormap (gray)%�����Ҫ����ͼΪ�Ҷ�����ͼ����
%     file_name=strcat(file_name(1:length(file_name)-4),'.bmp');%����ʱ������
% % imshow(y,'border','tight');%������ʾ����ͼ����
% %set(gcf,'position',[0,0,255,256]);%�趨 figure ��λ�úʹ�С���˴���СΪ 256*256
% %set(gca,'DataAspectRatio',[1,1,1]);%�������������ʱ����
% %set(gca,'position',[0,0,1,1]);%����������λ��ʱ����
% f=getframe(gcf); %ֱ�ӱ���Ϊ���ײ�ͼ�� ��С�������ز�������
% imwrite(f.cdata,str2,'.bmp');
% % imwrite(y,str2,'jpg');%����Ҫ������ͼ������д�����Ҫʹ�øú�������
% % saveas(gcf,str2,'jpg');%����ֱ�Ӳ�����С�̶�������ͼ�� ��Ҫʹ�øú�������
% close(gcf)
% end
% cd ..
% end


clc;
clear;
pic_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\SpecgramͼƬ\SESP\hand_open';
data_floder_path='E:\ʵ��\Delsys���ݲɼ�\ʵ������\13�ֶ���ģʽ\zhj20161031\�ָ�������\100-50\SESP\hand_open';

dir_output=dir(fullfile(data_floder_path,'*.mat'));
k=length(dir_output);%ͳ���ļ�����Ŀ
R=100;%���ô���������
window=hamming(R);%ʹ�ú�����

N=1024;%��ʱ����Ҷ��������
L=50;%����
overlap=R-L;%���ص�����
for i=1:k
file_name = dir_output(i).name;%��¼.mat �ļ�����
data=load(fullfile(data_floder_path,dir_output(i).name));
figure('visible','off');
picture=zeros(420,560,3);
for j=1:8
    [pic,f,t]=specgram(data.data_slice(:,j),N,2000,window,overlap);%��������ͼ
    y=20*log10(abs(pic)+eps);%����Ҫ��ת��ʵ��������
    imagesc (y);
    axis off;%�ر�����
    picture1=getframe(gcf); %ֱ�ӱ���Ϊ���ײ�ͼ�� ��С�������ز�������
    picture=picture+im2double(picture1.cdata);
 
end
picture=picture/8;
picture_uint8=im2uint8(picture);
RGB1=imcrop(picture_uint8,[80,40,350,320]);%����ͼ��,ȥ���ױ�
imagesc(RGB1);
RGB1=imresize(RGB1,[28,28]);%ͼ����СΪ28*28
% set(gcf,'position',[0,0,256,256]);
file_name=strcat(file_name(1:length(file_name)-4),'.jpg');%����ʱ������
imwrite(RGB1,fullfile(pic_floder_path,file_name),'jpg');
close (gcf);
end




        

