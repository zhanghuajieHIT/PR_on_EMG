function [ranked,MDTotal]=MDistance(data,label)
% MDistance:Mahalanobis distance
% class1:��һ
% class2:���
% ������MATLAB�Դ��ĺ���MAHAL����ΪЭ������󲻷���Ҫ��
% ranked:��kά������Ȩֵ������ά�е�����ֵ
% MDTotal:���е����Ͼ���֮��
% ����������ͬά�Ȳ�ͬ����ģʽ֮������Ͼ���

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

%% �������Ͼ���
featNumOneClass=length(label)/indexNum;%ÿ�ֶ�����������
MD=zeros(1,size(data,2));
for k=1:size(data,2)%��ÿһά����ÿ������������������Ͼ���
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
%% ����ranked
[~,rankedTemp]=sort(MD,'descend');
ranked=zeros(1,length(rankedTemp));
for i=1:length(rankedTemp)
    ranked(rankedTemp(i))=i;
end

end

