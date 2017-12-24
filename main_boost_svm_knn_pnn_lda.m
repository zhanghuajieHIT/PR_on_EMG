% boosting ˼�뽫���ַ����������һ��
% ����ͶƱ��
% ͨ��classifierCompare_Set�Ѿ�������˸���������������
% ���������'H:\�������ȽϽ������'��
% �ڱ���������У�predict_knnl1l2l3l4-k1k2k3k4-6-102,ָ����knn��������
% l1l2l3l4��ѵ������k1k2k3k4�ǲ��Լ���6��ָ�������ˣ�102��ָf����
% ������fsr��zhj��scy��zyh��xsp��zgj
% ��������97��MAV+WL+ZC+SSC��98��RMS+AR5��99��SE+WL+CC5+AR5��100��WT_WL��101��DFT_MAV2��102��TDPSD

clc;
clear;

label_num=6216;
class_num=14;
train_test_num=72;%ѵ�����Ͳ��Լ������������
file_path='H:\�������ȽϽ������';
classify_kind=2;%1����2,1��ʾsvm+pnn+lda��2��ʾsvm+pnn+knn

if classify_kind==1
    c_classify={'svm','pnn','lda'};%ע�⣬svm��������ǰ�棬��Ϊmode���������û���������򷵻ص�һ����
elseif classify_kind==2
    c_classify={'svm','pnn','knn'};
end

predict_label_total=zeros(label_num,length(c_classify),train_test_num);
predict_label=zeros(label_num,1);
acc=zeros(train_test_num,6,6);
label_temp=reshape(ones(label_num/(class_num*4),1)*(1:class_num),label_num/(class_num*4)*class_num,1);
test_label=repmat(label_temp,4,1);%����Ԥ����
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
