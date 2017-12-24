function [ranked,weightTotal]=FSReliefF(data,label)
% FSReliefF:feat select by ReliefF
% data:all data,samples*featdim
% label:samples*1
% ranked:��kά������Ȩֵ������ά�е�����ֵ

[rankedTemp,weight] = relieff(data,label,10);
weightTotal=sum(weight);
ranked=zeros(1,length(rankedTemp));
for i=1:length(rankedTemp)
    ranked(rankedTemp(i))=i;
end

end


