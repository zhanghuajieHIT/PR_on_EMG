function ZC = feature_ZC( y ,thresh)
% ZC:zero crossing
% Returns the number of times the signal amplitude in each bin crosses zero
% and the absolute difference in the values on each side of zero exceeds
% some threshold value thresh
% thresh:threshold,
% y:256*8
% 需要提前确定阈值thresh

[R, C] = size(y);
ZC = zeros(1, C);
% thresh=[4,6,4,2,3,3,2,2]*10^(-5);
if nargin==2
    if length(thresh)==1
        thresh=ones(C,1)*thresh;
    end
end
if nargin<2
    thresh=ones(C,1)*0.00003;
end
% ======计算阈值======
% load('E:\实验\Delsys数据采集\实验数据\zhj20161212\20-500Hz\无归一化无加窗\a1.mat');
% [index,~]=find(dataStructure.labelID==14);
% aver=mean(dataStructure.rawEMG(index,:));
% var=std(dataStructure.rawEMG(index,:));
% thresh=aver+var;
% ======计算阈值======

for i =1:C
    count = 0;
%     thresh=mean(y(:,i))-0.005*std(y(:,i));
    for j = 1: R-1
        if((((y(j,i) > 0) && (y(j+1,i) < 0))...
                || ((y(j,i) < 0) && (y(j+1,i) > 0)))...
                && abs(y(j,i) - y(j+1,i)) >= thresh(i))
        count = count + 1;
        end
    end
    ZC(1,i) = count;
end


end

