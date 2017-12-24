function result=readData(experimentTime,xlsFileName,experimentSession,isCover)
% read the data in the .xls file and calculate  average of the accuracy
% 如果运行途中不小心打开excel导致保存中断，再次执行即可。对于已经保存的会自动略过。
% experimentSession表示实验的组数
% isCover表示是否覆盖掉原来的计算结果

% xlsFileName='E:\实验\Delsys数据采集\实验记录\实验记录.xlsx';
% experimentTime='zhj20161226-1';

[data,text]=xlsread(xlsFileName,experimentTime);
[rowSavedAcc,~]=find(~isnan(data(:,1)));%已经保存过平均正确率的行数
index1=size(data,2);
[rowNan,~]=find(isnan(data(:,size(data,2))));
data(rowNan,:)=[];%将data中非数字去掉
[~,colNan]=find(isnan(data(1,:)));
data(:,colNan)=[];%将data中非数字去掉
index2=size(data,2);
if index1==index2
    rowSavedAcc=[];
end
averAcc=[];
for i=1:(size(data,1)/experimentSession)    %共有多少组特征：size(data,1)/experimentSession
    dataTemp=data(1+experimentSession*(i-1):experimentSession*i,:);
    for j=1:(experimentSession/2)
        for k=j:(experimentSession/2):experimentSession
            dataTemp(k,j)=0;%将对角线上的数据置0，因为不需要训练集和测试集相同的结果
        end
    end
    num=length(find(dataTemp));%得到结果不等于0的个数，及非对角线上的数据个数
    aver=sum(sum(dataTemp))/num;%计算平均正确率
    averAcc=cat(1,averAcc,aver);
end

% 保存结果
rowNotEmpty=~cellfun(@isempty,text(:,1));%找到没有第一列中的文本行（不包括数字）
[row,~]=find(rowNotEmpty);%找到没有第一列中的文本行（不包括数字）
[rowNotFeat,~]=find(diff(row)==1);%如果连续两行都有文本，说明只有最后一个文本后才有数据，其余的是前期操作出现了问题
row(rowNotFeat)=[];
if strcmp(isCover,'y')%覆盖原来的计算结果
    for i=1:length(row)
        xlswrite(xlsFileName,roundn(100*averAcc(i),-1),experimentTime,['A',num2str(row(i)+1)]);%row(i)+1为保存位置
    end
elseif strcmp(isCover,'n')%不覆盖
    for i=length(rowSavedAcc)+1:length(row)
        xlswrite(xlsFileName,roundn(100*averAcc(i),-1),experimentTime,['A',num2str(row(i)+1)]);%row(i)+1为保存位置
    end
else
    assert('请确定是否覆盖原数据');
end

%% 对正确率降序排列，并得到对应的特征
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
% permNum=size(word,1);%排列组合后的数目
% for ii=1:permNum
% for i=1:lenS
%     if strcmp(s(i:i-1+lenW),word(ii))==1
%         indexNum=cat(1,indexNum,i);
%         i=i+lenW;%这种操作不一定可行???
%     end
% end
% end
% 
% end

