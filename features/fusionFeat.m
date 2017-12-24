function feat=fusionFeat(fun,data)
% 计算组合特征
% data:256*8

funNum=length(fun);
feat=[];
for i=1:funNum
   func=fun{i};
   feat=cat(2,feat,feval(func,data));    
end

end