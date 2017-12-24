function [predictLabel]=adaboostSVM_predict(data,label,Model)
h=zeros(Model.iter,1);
for i = 1:Model.iter
   [predictTemp(i,:),~,~]=libsvmpredict(label,data,Model.model{1,i});
   
   h(i)=predictTemp(i,:);
end
predictLabelTemp= sign(Model.at'*h);

%% 还原为原来的label
if predictLabelTemp==1
    predictLabel=Model.oldLabel(1);
else
    predictLabel=Model.oldLabel(2);
end

end
