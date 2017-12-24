function [ranked,ratioTotal]=FisherRatio(data,label)
% FisherRatio:fisher ratio
% trainData:all data,samples*featdim
% trainLabel:samples*1
% ranked:第k维特征的权值在所有维中的排序值

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

%% 计算类间均值方差和类内平均方差
averTotal=mean(data);
featNumOneClass=length(label)/indexNum;%每种动作的样本数
intraClassTemp=zeros(1,size(data,2));
interClassTemp=zeros(1,size(data,2));
for i=1:indexNum
    temp=data(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass,:);
    aver=mean(temp);
    oneClassTemp=(1/featNumOneClass)*sum((bsxfun(@minus,temp,aver)).^2);
    intraClassTemp=oneClassTemp+intraClassTemp;
    interClassTemp=interClassTemp+(bsxfun(@minus,aver,averTotal)).^2;
end
intraClass=intraClassTemp/indexNum;%类内平均方差
interClassTemp=interClassTemp/indexNum;%类间均值方差

%% 比值并排序
ratio=interClassTemp./intraClass;
ratioTotal=sum(ratio);
[~,rankedTemp]=sort(ratio,'descend');%ranked指Fisher比值按降序排列对应的数据原始位置
ranked=zeros(1,length(rankedTemp));
for i=1:length(rankedTemp)
    ranked(rankedTemp(i))=i;
end

end

