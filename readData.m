function result=readData(experimentTime,xlsFileName,experimentSession,isCover)
% read the data in the .xls file and calculate  average of the accuracy
% �������;�в�С�Ĵ�excel���±����жϣ��ٴ�ִ�м��ɡ������Ѿ�����Ļ��Զ��Թ���
% experimentSession��ʾʵ�������
% isCover��ʾ�Ƿ񸲸ǵ�ԭ���ļ�����

% xlsFileName='E:\ʵ��\Delsys���ݲɼ�\ʵ���¼\ʵ���¼.xlsx';
% experimentTime='zhj20161226-1';

[data,text]=xlsread(xlsFileName,experimentTime);
[rowSavedAcc,~]=find(~isnan(data(:,1)));%�Ѿ������ƽ����ȷ�ʵ�����
index1=size(data,2);
[rowNan,~]=find(isnan(data(:,size(data,2))));
data(rowNan,:)=[];%��data�з�����ȥ��
[~,colNan]=find(isnan(data(1,:)));
data(:,colNan)=[];%��data�з�����ȥ��
index2=size(data,2);
if index1==index2
    rowSavedAcc=[];
end
averAcc=[];
for i=1:(size(data,1)/experimentSession)    %���ж�����������size(data,1)/experimentSession
    dataTemp=data(1+experimentSession*(i-1):experimentSession*i,:);
    for j=1:(experimentSession/2)
        for k=j:(experimentSession/2):experimentSession
            dataTemp(k,j)=0;%���Խ����ϵ�������0����Ϊ����Ҫѵ�����Ͳ��Լ���ͬ�Ľ��
        end
    end
    num=length(find(dataTemp));%�õ����������0�ĸ��������ǶԽ����ϵ����ݸ���
    aver=sum(sum(dataTemp))/num;%����ƽ����ȷ��
    averAcc=cat(1,averAcc,aver);
end

% ������
rowNotEmpty=~cellfun(@isempty,text(:,1));%�ҵ�û�е�һ���е��ı��У����������֣�
[row,~]=find(rowNotEmpty);%�ҵ�û�е�һ���е��ı��У����������֣�
[rowNotFeat,~]=find(diff(row)==1);%����������ж����ı���˵��ֻ�����һ���ı���������ݣ��������ǰ�ڲ�������������
row(rowNotFeat)=[];
if strcmp(isCover,'y')%����ԭ���ļ�����
    for i=1:length(row)
        xlswrite(xlsFileName,roundn(100*averAcc(i),-1),experimentTime,['A',num2str(row(i)+1)]);%row(i)+1Ϊ����λ��
    end
elseif strcmp(isCover,'n')%������
    for i=length(rowSavedAcc)+1:length(row)
        xlswrite(xlsFileName,roundn(100*averAcc(i),-1),experimentTime,['A',num2str(row(i)+1)]);%row(i)+1Ϊ����λ��
    end
else
    assert('��ȷ���Ƿ񸲸�ԭ����');
end

%% ����ȷ�ʽ������У����õ���Ӧ������
[newOrder,oldLoc]=sort(averAcc,'descend');
result.averAcc=newOrder;
result.feat=text(row(oldLoc),:);

end


% function indexNum=main(s,wordNum,Word)
% lenW=length(Word);
% lenS=length(s);
% indexNum=[];
% for i=1:lenW/wordNum:wordNum
%     wordNew{i}=Word(i:i-1+lenW/wordNum);
% end
% word=perms(wordNew);
% permNum=size(word,1);%������Ϻ����Ŀ
% for ii=1:permNum
% for i=1:lenS
%     if strcmp(s(i:i-1+lenW),word(ii))==1
%         indexNum=cat(1,indexNum,i);
%         i=i+lenW;%���ֲ�����һ������???
%     end
% end
% end
% 
% end

