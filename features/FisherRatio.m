function [ranked,ratioTotal]=FisherRatio(data,label)
% FisherRatio:fisher ratio
% trainData:all data,samples*featdim
% trainLabel:samples*1
% ranked:��kά������Ȩֵ������ά�е�����ֵ

%% ��������
index=unique(label);
indexNum=length(index);% indexNum=14������������
dataTemp=[];
labelTemp=[];
for i=1:indexNum
    [row,~]=find(label==index(i));
    dataTemp=cat(1,dataTemp,data(row,:));
    labelTemp=cat(1,labelTemp,label(row));
end
data=dataTemp;%���ݰ���label�������ź�
label=labelTemp;

%% ��������ֵ���������ƽ������
averTotal=mean(data);
featNumOneClass=length(label)/indexNum;%ÿ�ֶ�����������
intraClassTemp=zeros(1,size(data,2));
interClassTemp=zeros(1,size(data,2));
for i=1:indexNum
    temp=data(1+(i-1)*featNumOneClass:featNumOneClass+(i-1)*featNumOneClass,:);
    aver=mean(temp);
    oneClassTemp=(1/featNumOneClass)*sum((bsxfun(@minus,temp,aver)).^2);
    intraClassTemp=oneClassTemp+intraClassTemp;
    interClassTemp=interClassTemp+(bsxfun(@minus,aver,averTotal)).^2;
end
intraClass=intraClassTemp/indexNum;%����ƽ������
interClassTemp=interClassTemp/indexNum;%����ֵ����

%% ��ֵ������
ratio=interClassTemp./intraClass;
ratioTotal=sum(ratio);
[~,rankedTemp]=sort(ratio,'descend');%rankedָFisher��ֵ���������ж�Ӧ������ԭʼλ��
ranked=zeros(1,length(rankedTemp));
for i=1:length(rankedTemp)
    ranked(rankedTemp(i))=i;
end

end

