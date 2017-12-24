function label_out=lda_out(Model,Classifier_Pra,predict_attr)
% Initialize preidcting and updating parameters
num_predict=size(predict_attr,1);
class_num=Classifier_Pra.class_num;
twoclass_num=Classifier_Pra.twoclass_num;
twoclass_label=Classifier_Pra.twoclass_label;
class_vote=zeros(num_predict,class_num);
% Make predictions
for L=1:twoclass_num
    model=Model{L};
    c1=twoclass_label(1,L);
    c2=twoclass_label(2,L);    
    %result_pos=diag((predict_attr-ones(num_predict,1)*model.mu_pos)*inv(model.sigma)*(predict_attr-ones(num_predict,1)*model.mu_pos)');
    %result_neg=diag((predict_attr-ones(num_predict,1)*model.mu_neg)*inv(model.sigma)*(predict_attr-ones(num_predict,1)*model.mu_neg)');    
    %predict_label=result_neg-result_pos;
    predict_label=(predict_attr-0.5*ones(num_predict,1)*(model.mu_pos+model.mu_neg))*inv(model.sigma)*(model.mu_pos-model.mu_neg)'+0.5*ones(num_predict,1);
    jud_pos=predict_label>0;
    jud_neg=predict_label<0;
    jud_zero=predict_label==0;
    class_vote(jud_pos,c1)=class_vote(jud_pos,c1)+1;
    class_vote(jud_zero,c1)=class_vote(jud_zero,c1)+0.5;
    class_vote(jud_neg,c2)=class_vote(jud_neg,c2)+1;
    class_vote(jud_zero,c2)=class_vote(jud_zero,c2)+0.5;    
end
[invalid,label_out]=max(class_vote,[],2);
