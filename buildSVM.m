function [model,predictLabel,error]=buildSVM(data,label,D,num)
error=0;
cmd=['-c ',num2str(50),' -g ',num2str(1+2*num)];
model = libsvmtrain(label, data, cmd);
[predictLabel, ~,~] = libsvmpredict(label, data, model);
% best_label=predictLabel';
% Label=unique(label);
% index1=find(best_label==Label(1));
% index2=find(best_label==Label(2));
% bestLabel(index1)=1;
% bestLabel(index2)=-1;
for i=1:length(D)%1:m
    if predictLabel(i)~=label(i)
        error=error+D(i);
    end
end
end