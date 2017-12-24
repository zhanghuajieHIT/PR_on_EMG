function center=center_matrix(data,label,classify_kind)
% data��label�Ǿ�������͹�һ������
% ���ڼ���Ԥ����ȷ������������,center�Ǹ������������
% ����kmeans
% ����ʵ��lda��svm

class_num=length(unique(label));%���ж�����
sample_num=length(label)/class_num;%ÿ���ж�������
dim=size(data,2);

if strcmp(classify_kind,'svm')
    center=zeros(class_num,dim);
    model=libsvmtrain(label,data,'-c 32 -g 0.01');
    [predict_label,~,~]=libsvmpredict(label,data,model);
    index=find(predict_label==label);
    for i=1:class_num
        temp=(index<=sample_num*(i-1)+sample_num)&(index>sample_num*(i-1));
        data_index=index(temp);
        matrix_temp=data(data_index);
        [~,center(i,:)]=kmeans(matrix_temp,1);%����������������������
    end
elseif strcmp(classify_kind,'lda')
    center=zeros(class_num,dim);
    model=fitcdiscr(data,label);
    predict_label=predict(model,data);
    
%     Classifier_Pra.class_num=class_num;
%     Classifier_Pra.twoclass_num=Classifier_Pra.class_num*(Classifier_Pra.class_num-1)/2;
%     twoclass_label=zeros(2,Classifier_Pra.twoclass_num);
%     c1=1;
%     c2=1;
%     for L=1:Classifier_Pra.twoclass_num
%         if c2<Classifier_Pra.class_num
%             c2=c2+1;
%         else
%             c1=c1+1;
%             c2=c1+1;
%         end
%         twoclass_label(1,L)=c1;
%         twoclass_label(2,L)=c2;
%     end
%     Classifier_Pra.twoclass_label=twoclass_label;
%     predict_label=zeros(length(label),1);
%     for j=1:length(label)
%         predict_label(j)=LDA_out_hq(model,Classifier_Pra,data(j,:));
%     end
    index=find(predict_label==label);
    for i=1:class_num
        temp=(index<=sample_num*(i-1)+sample_num)&(index>sample_num*(i-1));
        data_index=index(temp);
        matrix_temp=data(data_index,:);
        [~,center(i,:)]=kmeans(matrix_temp,1);
    end    
     
end

end
