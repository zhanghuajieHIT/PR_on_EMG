function [data,output]=compute_cmData(target_label,predict_label)
%% ���������������Ҫ�õ�������
[output,~]=confusionmat(target_label,predict_label);
data=output./(sum(output,2)*ones(1,size(output,2)));
end