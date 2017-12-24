function [predictLabel]=adaboostNB_predict(data,label,Model)
h=zeros(Model.iter,1);
for i = 1:Model.iter
   predictTemp(i,:)=predict(Model.nb{1,i},data);
   
   h(i)=predictTemp(i,:);
end
predictLabelTemp= sign(Model.at'*h);

%% ��ԭΪԭ����label
if predictLabelTemp==1
    predictLabel=Model.oldLabel(1);
else
    predictLabel=Model.oldLabel(2);
end

end