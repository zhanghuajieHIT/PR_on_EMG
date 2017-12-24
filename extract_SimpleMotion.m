function [data,label]=extract_SimpleMotion(dataOld,labelOld)
%%���ڼ򵥶����͸��Ӷ������ݵ���ȡ
% ����1,2,5,6,12,13,14�Ǽ򵥶����飬
% ����1��14�Ǹ��Ӷ�����
% �������������

simpleMotion=[1,2,5,6,12,13,14];
simpleIndex=[];
for i=1:length(simpleMotion)
    simpleIndexTemp=find(labelOld==simpleMotion(i));
    simpleIndex=cat(1,simpleIndex,simpleIndexTemp);
end
data=dataOld(simpleIndex,:);
label=labelOld(simpleIndex);

end

