function [predictLabel]=adaboostBP_predict(data,label,Model)
data=data';
for i = 1:Model.iter
   predictTest(i,:)=sim(Model.net{1,i},data); 
end

predictLabelTemp= sign(Model.at'*predictTest);

%% 还原为原来的label
if predictLabelTemp==1
    predictLabel=Model.oldLabel(1);
else
    predictLabel=Model.oldLabel(2);
end


end

