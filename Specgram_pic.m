%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%本函数实现EMG信号的STFT图形生成，并保存在指定的文件夹中
%每个通道都有对应的STFT图形，最后保存的是8通道图形RGB的平均值
%by zhanghuajie
%2016/11/13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function Specgram_pic(pic_floder_path,data_floder_path)

% pic_floder_path是指图片保存的文件夹
% data_floder_path是指需要转换为图片的数据所在的文件夹

% clc;
% clear;
% pic_floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\Specgram图片\SESP\cylinder_grasp';
% data_floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\分割后的数据\100-50\SESP\cylinder_grasp';
% 
% dir_output=dir(fullfile(data_floder_path,'*.mat'));
% k=length(dir_output);%统计文件的数目
% R=1024;%设置窗函数长度
% window=hamming(R);%使用汉明窗
% N=1024;%短时傅立叶函数点数
% L=512;%步长
% overlap=R-L;%窗重叠点数
% for i=1:k
% file_name = dir_output(i).name;%记录.mat 文件名字
% % [x,fs]=auread(dir_output(i).name);%读取.au 文件
% data=load(fullfile(data_floder_path,dir_output(i).name));
% figure('visible','off');
% % x= awgn(x,100,'measured','linear');%增加了高斯白噪声
% % x= x(1:3.2:end,1); %如需要对于音乐采样调用该函数
% 
% for j=1:8
%     [pic,f,t]=specgram(data(:,j),N,2000,window,overlap);%生成声谱图
%     %y=20*log10(abs(s)+eps);%如需要在转换实数和虚数
%     %[y,PS] = mapminmax(y,0,1);%如需要归一化成[0， 1]调用
%     %[y,PS] = mapminmax(y,-1,1);%如需要归一化成[-1， 1]调用
%     %y = y*255;%归一化后需转化成声谱图调用
%     %y=uint8(y);%归一化后需转化成声谱图调用
%     axis off;%关闭坐标
%     imagesc(y)%把矩阵绘制成图时调用 
%     colormap (gray)%如果需要声谱图为灰度声谱图调用
%     file_name=strcat(file_name(1:length(file_name)-4),'.bmp');%保存时的名称
% % imshow(y,'border','tight');%如需显示声谱图调用
% %set(gcf,'position',[0,0,255,256]);%设定 figure 的位置和大小，此处大小为 256*256
% %set(gca,'DataAspectRatio',[1,1,1]);%调整坐标轴比率时调用
% %set(gca,'position',[0,0,1,1]);%调整坐标轴位置时调用
% f=getframe(gcf); %直接保存为声谱彩图， 大小由上面呢参数决定
% imwrite(f.cdata,str2,'.bmp');
% % imwrite(y,str2,'jpg');%如需要对声谱图矩阵进行处理，需要使用该函数保存
% % saveas(gcf,str2,'jpg');%如需直接产生大小固定的声谱图， 需要使用该函数保存
% close(gcf)
% end
% cd ..
% end


clc;
clear;
pic_floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\Specgram图片\SESP\hand_open';
data_floder_path='E:\实验\Delsys数据采集\实验数据\13种动作模式\zhj20161031\分割后的数据\100-50\SESP\hand_open';

dir_output=dir(fullfile(data_floder_path,'*.mat'));
k=length(dir_output);%统计文件的数目
R=100;%设置窗函数长度
window=hamming(R);%使用汉明窗

N=1024;%短时傅立叶函数点数
L=50;%步长
overlap=R-L;%窗重叠点数
for i=1:k
file_name = dir_output(i).name;%记录.mat 文件名字
data=load(fullfile(data_floder_path,dir_output(i).name));
figure('visible','off');
picture=zeros(420,560,3);
for j=1:8
    [pic,f,t]=specgram(data.data_slice(:,j),N,2000,window,overlap);%生成声谱图
    y=20*log10(abs(pic)+eps);%如需要在转换实数和虚数
    imagesc (y);
    axis off;%关闭坐标
    picture1=getframe(gcf); %直接保存为声谱彩图， 大小由上面呢参数决定
    picture=picture+im2double(picture1.cdata);
 
end
picture=picture/8;
picture_uint8=im2uint8(picture);
RGB1=imcrop(picture_uint8,[80,40,350,320]);%剪切图形,去除白边
imagesc(RGB1);
RGB1=imresize(RGB1,[28,28]);%图像缩小为28*28
% set(gcf,'position',[0,0,256,256]);
file_name=strcat(file_name(1:length(file_name)-4),'.jpg');%保存时的名称
imwrite(RGB1,fullfile(pic_floder_path,file_name),'jpg');
close (gcf);
end




        

