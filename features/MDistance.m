function [ranked,MDTotal]=MDistance(data,label)
% MDistance:Mahalanobis distance
% class1:类一
% class2:类二
% 不能用MATLAB自带的函数MAHAL，因为协方差矩阵不符合要求
% ranked:第k维特征的权值在所有维中的排序值
% MDTotal:所有的马氏距离之和
% 计算特征不同维度不同动作模式之间的马氏距离

%% 数据排序
index=unique(label);
indexNum=length(index);% indexNum=14，动作种类数
dataTemp=[];
labelTemp=[];
for i=1:indexNum
    [row,~]=find(label==index(i));
    dataTemp=cat(1,dataTemp,data(row,:));
    labelTemp=cat(1,labelTemp,label(row));
end
data=dataTemp;%数据按照label的升序排好
label=labelTemp;

%% 计算马氏距离
featNumOneClass=length(label)/indexNum;%每种动作的样本数
MD=zeros(1,size(data,2));
for k=1:size(data,2)%对每一维度求每两类样本特征间的马氏距离
    MDTemp=[];
    for i=1:indexNum-1
        class1=data(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass,k);
        class1Mean=mean(class1);
        for j=i+1:indexNum
            class2=data(1+(j-1)*featNumOneClass:j*featNumOneClass,k);
            class2Mean=mean(class2);
            classTotal=[class1;class2];
            covarInv=inv(cov(classTotal));
            MDTemp=cat(1,MDTemp,sum((class1Mean-class2Mean)*covarInv.*(class1Mean-class2Mean),2));
        end
    end
    MD(k)=sum(MDTemp);        
end
MDTotal=sum(MD);
%% 计算ranked
[~,rankedTemp]=sort(MD,'descend');
ranked=zeros(1,length(rankedTemp));
for i=1:length(rankedTemp)
    ranked(rankedTemp(i))=i;
end

end

