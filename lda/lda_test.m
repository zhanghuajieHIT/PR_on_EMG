%% �Ա�д��lda
%����ĸ�ʽ��model,data��label�����ΪԤ��Ľ������ȷ��
function [predict_label,acc]=lda_test(model,data,label)
%�������û��������Ҫ��������
[data,label]=data_sort(data,label);
class_num=length(unique(label));
sample_size=length(label)/class_num;
% sample_dim=size(data,2);
label_out=zeros(sample_size*class_num,1);
% compare_label=reshape(meshgrid(1:class_num,1:sample_size),class_num*sample_size,1);


model_Temp=model.model_Temp;
Classifier_Pra=model.Classifier_Pra;
for i=1:class_num
%     ground_truth=compare_label((i-1)*sample_size+1:i*sample_size);
    predict_attr=data((i-1)*sample_size+1:i*sample_size,:);
    label_out((i-1)*sample_size+1:i*sample_size,1)=lda_out(model_Temp,Classifier_Pra,predict_attr);%�Ա�дpredict����
end
predict_label=label_out;
acc=length(find(predict_label==label))/length(label);

end
