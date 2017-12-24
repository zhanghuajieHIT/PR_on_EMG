function [data,label]=extract_SimpleMotion(dataOld,labelOld)
%%用于简单动作和复杂动作数据的提取
% 动作1,2,5,6,12,13,14是简单动作组，
% 动作1—14是复杂动作组
% 还有排序的作用

simpleMotion=[1,2,5,6,12,13,14];
simpleIndex=[];
for i=1:length(simpleMotion)
    simpleIndexTemp=find(labelOld==simpleMotion(i));
    simpleIndex=cat(1,simpleIndex,simpleIndexTemp);
end
data=dataOld(simpleIndex,:);
label=labelOld(simpleIndex);

end

