clc;
clear;
%% 在线学习主函数
load('H:\特征保存\fsr20170325\特征保存\feature_DFT_MAV-b1b2b3b4.mat');
data1=featSaved(:,1:end-1);
test1=featSaved(:,end);
[data1,test1]=data_sort(data1,test1);
% load('H:\特征保存\fsr20170325\特征保存\feature_DFT_MAV-c1c2c3c4.mat');
% data2=featSaved(:,1:end-1);
% test2=featSaved(:,end);
% [data2,test2]=data_sort(data2,test2);
temp={'d1d2d3d4','f1f2f3f4','h1h2h3h4','j1j2j3j4','l1l2l3l4'};
% tic
ACC=[];
model1=libsvmtrain(test1,sparse(data1),'-s 2');

for kk=1:1
    flodpath=cellstr(temp{kk});
load(['H:\特征保存\fsr20170325\特征保存\feature_DFT_MAV-',cell2mat(flodpath),'.mat']);
data3=featSaved(:,1:end-1);
test3=featSaved(:,end);
[data3,test3]=data_sort(data3,test3);

center=zeros(14,size(data1,2));
% for i=1:14
%     [~,center(i,:)]=kmeans(data1((i-1)*444+1:i*444,:),1);%14类数据的中心
% end
% tic
% model1=libsvmtrain(test1,sparse(data1),'-s 2');
% toc

%% 预测
% tic
predictLabel_old=test1;
data_old=data1;
count=0;
for ii=1:length(test3)
    
%     for i=1:14
        [~,center]=kmeans(data_old,14);%14类数据的中心
%     end
    
    [predict_label(ii),~,~]=libsvmpredict(1,sparse(data3(ii,:)),model1);
    
    for i=1:14
        Dist(i)=pdist([center(i,:);data3(ii,:)],'euclidean'); 
    end
    [~,index(ii)]=min(Dist);
    if index(ii)==predict_label(ii)
        predictLabel_new=predict_label(ii);
%         data_new=data3(ii);
%         predictLabel_old=cat(1,predictLabel_old,test1(ii));
%         data_old=cat(1,data_old,data1(ii,:));
    
    model2=libsvmtrain([predictLabel_old;predictLabel_new],[sparse(data_old);sparse(data3(ii,:))],'-s 2 -i model1');
    model1=model2;
    predictLabel_old=cat(1,predictLabel_old,predictLabel_new);
    data_old=cat(1,data_old,data3(ii,:));
    count=count+1;
    end
end
acc=length(find(predict_label'==test3))/length(test3);
% toc
ACC=cat(1,ACC,acc);

end
% toc
