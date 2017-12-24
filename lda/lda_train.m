%% 自编写的lda
%输入的格式是data和label，输出为model
function Model=lda_train(data,label)
%如果数据没有排序，先要进行排序
[data,label]=data_sort(data,label);

class_num=length(unique(label));
sample_size=length(label)/class_num;
sample_dim=size(data,2);

twoclass_num=class_num*(class_num-1)/2;
twoclass_label=zeros(2,twoclass_num);
c1=1;
c2=1;
for L=1:twoclass_num
    if c2<class_num
        c2=c2+1;
    else
        c1=c1+1;
        c2=c1+1;
    end
    twoclass_label(1,L)=c1;
    twoclass_label(2,L)=c2;
end
Classifier_Pra.twoclass_label=twoclass_label;
Classifier_Pra.class_num=class_num;
Classifier_Pra.sample_size=sample_size;
Classifier_Pra.sample_dim=sample_dim;
Classifier_Pra.twoclass_num=twoclass_num;

Sample_attr=zeros(sample_size,sample_dim,class_num);

Y_two=[ones(sample_size,1);-1*ones(sample_size,1)];
for i=1:class_num
    Sample_attr(:,:,i)=data((i-1)*sample_size+1:i*sample_size,1:sample_dim);
end

for L=1:twoclass_num
    c1=twoclass_label(1,L);
    c2=twoclass_label(2,L);
    train_attr=[Sample_attr(:,:,c1);Sample_attr(:,:,c2)];
    model_temp=lda_zhj(train_attr,Y_two);%自编写lda函数
    Model.model_Temp{L}=model_temp;
end
Model.Classifier_Pra=Classifier_Pra;

end