%% 清空环境变量
close all;
clear;
clc;
format compact;
%% 数据提取
%每次对不同的数据进行分类识别时，需要修改下面的路径
datatrain1=load ('E:\实验\开题前期实验\实验数据\20160709\201600709-12data11.mat');
datatrain2=load ('E:\实验\开题前期实验\实验数据\20160709\201600709-12data12.mat');
datatrain3=load ('E:\实验\开题前期实验\实验数据\20160709\201600709-12data13.mat');
%datatrain4=load ('C:\Users\zhanghuajie\Desktop\20160723\20160723-7data14.mat');
datatrain.predictors=[datatrain1.predictors;datatrain2.predictors;datatrain3.predictors];
% datatrain=datatrain1;
datatrain_label1=load ('E:\实验\开题前期实验\实验数据\20160709\201600709-12data11-1.mat');
datatrain_label2=load ('E:\实验\开题前期实验\实验数据\20160709\201600709-12data12-1.mat');
datatrain_label3=load ('E:\实验\开题前期实验\实验数据\20160709\201600709-12data13-1.mat');
%datatrain_label4=load ('C:\Users\zhanghuajie\Desktop\20160723\20160723-7data14-1.mat');
datatrain_label.response=[datatrain_label1.response;datatrain_label2.response;datatrain_label3.response];
% datatrain_label=datatrain_label1;
datatest=load('E:\实验\开题前期实验\实验数据\20160709\201600709-12data33.mat');
datatest_label=load('E:\实验\开题前期实验\实验数据\20160709\201600709-12data33-1.mat');

%% 数据预处理
% 数据预处理,将训练集和测试集归一化到[0,1]区间

[mtrain,ntrain] = size(datatrain.predictors);
[mtest,ntest] = size(datatest.predictors);

%将文字标签转换为数字
datatrain_numlabel=zeros(mtrain,1);
for i=1:mtrain
    if(strcmp(datatrain_label.response(i,1),'Wrist Flex In'))
        datatrain_numlabel(i,1)=1;   
    elseif(strcmp(datatrain_label.response(i,1),'Wrist Extend Out'))
        datatrain_numlabel(i,1)=2; 
    elseif(strcmp(datatrain_label.response(i,1),'Hand Open'))
        datatrain_numlabel(i,1)=3; 
    elseif(strcmp(datatrain_label.response(i,1),'No Movement'))
        datatrain_numlabel(i,1)=4;
    elseif(strcmp(datatrain_label.response(i,1),'Lateral Grasp'))
        datatrain_numlabel(i,1)=5;
    elseif(strcmp(datatrain_label.response(i,1),'Spherical Grasp'))
        datatrain_numlabel(i,1)=6;
    elseif(strcmp(datatrain_label.response(i,1),'Cylindrical Grasp'))
        datatrain_numlabel(i,1)=7;
    elseif(strcmp(datatrain_label.response(i,1),'Tripod Grasp'))
        datatrain_numlabel(i,1)=8;
    elseif(strcmp(datatrain_label.response(i,1),'Index Grasp'))
        datatrain_numlabel(i,1)=9;
    elseif(strcmp(datatrain_label.response(i,1),'Wrist Rotate In'))
        datatrain_numlabel(i,1)=10;
    elseif(strcmp(datatrain_label.response(i,1),'Power Grasp'))
        datatrain_numlabel(i,1)=11;
    elseif(strcmp(datatrain_label.response(i,1),'Wrist Rotate Out'))
        datatrain_numlabel(i,1)=12;
    end
end

datatest_numlabel=zeros(mtest,1);
for i=1:mtest
    if(strcmp(datatest_label.response(i,1),'Wrist Flex In'))
        datatest_numlabel(i,1)=1;   
    elseif(strcmp(datatest_label.response(i,1),'Wrist Extend Out'))
        datatest_numlabel(i,1)=2; 
    elseif(strcmp(datatest_label.response(i,1),'Hand Open'))
        datatest_numlabel(i,1)=3; 
    elseif(strcmp(datatest_label.response(i,1),'No Movement'))
        datatest_numlabel(i,1)=4;
    elseif(strcmp(datatest_label.response(i,1),'Lateral Grasp'))
        datatest_numlabel(i,1)=5;
    elseif(strcmp(datatest_label.response(i,1),'Spherical Grasp'))
        datatest_numlabel(i,1)=6;
    elseif(strcmp(datatest_label.response(i,1),'Cylindrical Grasp'))
        datatest_numlabel(i,1)=7;
    elseif(strcmp(datatest_label.response(i,1),'Tripod Grasp'))
        datatest_numlabel(i,1)=8;
    elseif(strcmp(datatest_label.response(i,1),'Index Grasp'))
        datatest_numlabel(i,1)=9;
    elseif(strcmp(datatest_label.response(i,1),'Wrist Rotate In'))
        datatest_numlabel(i,1)=10;
    elseif(strcmp(datatest_label.response(i,1),'Power Grasp'))
        datatest_numlabel(i,1)=11;
    elseif(strcmp(datatest_label.response(i,1),'Wrist Rotate Out'))
        datatest_numlabel(i,1)=12;
    end
end

dataset = [datatrain.predictors;datatest.predictors];
% mapminmax为MATLAB自带的归一化函数
[dataset_scale,ps] = mapminmax(dataset',0,1);
dataset_scale = dataset_scale';

train_data = dataset_scale(1:mtrain,:);
test_data = dataset_scale( (mtrain+1):(mtrain+mtest),: );
%% SVM网络训练
model = svmtrain(datatrain_numlabel, train_data, '-c 2 -g 1');

%% SVM网络预测
[predict_label, accuracy,~] = svmpredict(datatest_numlabel, test_data, model);

%% 结果分析

% 测试集的实际分类和预测分类图
% 通过图可以看出只有一个测试样本是被错分的
% figure;
% hold on;
% plot(test_wine_labels,'o');
% plot(predict_label,'r*');
% xlabel('测试集样本','FontSize',12);
% ylabel('类别标签','FontSize',12);
% legend('实际测试集分类','预测测试集分类');
% title('测试集的实际分类和预测分类图','FontSize',12);
% grid on;


