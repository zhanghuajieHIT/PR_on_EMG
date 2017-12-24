function [data,output]=compute_cmData(target_label,predict_label)
%% 计算混淆矩阵所需要用到的数据
[output,~]=confusionmat(target_label,predict_label);
data=output./(sum(output,2)*ones(1,size(output,2)));
end