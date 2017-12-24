% boosting 思想将三种分类器组合在一起
% 采用投票法
% 通过classifierCompare_Set已经计算好了各分类器的输出结果
% 结果保存在'H:\分类器比较结果保存'中
% 在保存的数据中，predict_knnl1l2l3l4-k1k2k3k4-6-102,指的是knn分类器，
% l1l2l3l4是训练集，k1k2k3k4是测试集，6是指第六个人，102是指f特征
% 人排序：fsr、zhj、scy、zyh、xsp、zgj
% 特征排序：97：MAV+WL+ZC+SSC，98：RMS+AR5，99：SE+WL+CC5+AR5，100：WT_WL，101：DFT_MAV2，102：TDPSD

clc;
clear;

label_num=6216;
class_num=14;
train_test_num=72;%训练集和测试集的排列组合数
file_path='H:\分类器比较结果保存';
classify_kind=2;%1或者2,1表示svm+pnn+lda；2表示svm+pnn+knn

if classify_kind==1
    c_classify={'svm','pnn','lda'};%注意，svm必须在最前面，因为mode函数，如果没有众数，则返回第一个数
elseif classify_kind==2
    c_classify={'svm','pnn','knn'};
end

predict_label_total=zeros(label_num,length(c_classify),train_test_num);
predict_label=zeros(label_num,1);
acc=zeros(train_test_num,6,6);
label_temp=reshape(ones(label_num/(class_num*4),1)*(1:class_num),label_num/(class_num*4)*class_num,1);
test_label=repmat(label_temp,4,1);%期望预测结果
for i=1:6
    for j=97:102
        for k=1:length(c_classify)
            classify_name=c_classify{k};
            dirout=dir([file_path,'\predict_',classify_name,'*',num2str(i),'-',num2str(j),'.mat']);
            for ii=1:length(dirout)
                load([file_path,'\',dirout(ii).name]);
                predict_label_total(:,k,ii)=eval(['predict_',classify_name]);
            end
        end
        for jj=1:size(predict_label_total,3)
            for kk=1:size(predict_label_total,1)
                predict_label(kk)=mode(predict_label_total(kk,:,jj));
            end
            acc(jj,j-96,i)=length(find(predict_label==test_label))/label_num;
        end
    end
end
save('acc.mat','acc');
