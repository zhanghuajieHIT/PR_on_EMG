function [SV,label_out]=Incre_svm_update(SV,Classifier_Pra,predict_attr,ground_truth,supervise_flag)

num_predict=size(predict_attr,1);
class_num=Classifier_Pra.class_num;
twoclass_num=Classifier_Pra.twoclass_num;
twoclass_label=Classifier_Pra.twoclass_label;
sigma=Classifier_Pra.sigma;
% C=Classifier_Pra.C;
class_vote=zeros(num_predict,class_num);
% Make predictions
for L=1:twoclass_num
    c1=twoclass_label(1,L);
    c2=twoclass_label(2,L);
    nsv=SV(L).total_nsv;
    coef=SV(L).coef*ones(1,num_predict);
    predict_label=(sum(k_matrix(SV(L).attr,sigma,nsv,predict_attr).*coef,1))'-SV(L).rho;    
    jud_pos=predict_label>0;
    jud_neg=predict_label<0;
    jud_zero=predict_label==0;
    class_vote(jud_pos,c1)=class_vote(jud_pos,c1)+1;
    class_vote(jud_zero,c1)=class_vote(jud_zero,c1)+0.5;
    class_vote(jud_neg,c2)=class_vote(jud_neg,c2)+1;
    class_vote(jud_zero,c2)=class_vote(jud_zero,c2)+0.5;    
end
[invalid,label_out]=max(class_vote,[],2);

for L=1:twoclass_num
    c1=twoclass_label(1,L);
    c2=twoclass_label(2,L);
    % Judge whether to update
    if supervise_flag==1
        train_pos=ground_truth==c1;
        train_neg=ground_truth==c2;        
    else
        train_pos=label_out==c1;
        train_neg=label_out==c2;        
    end
    % Update    
    if (sum(train_pos)+sum(train_neg))>0
        n_pos=sum(train_pos);
        n_neg=sum(train_neg);
        label_new=[ones(n_pos,1);-1*ones(n_neg,1)];
        label_old=SV(L).label;
        Train_attr=[predict_attr(train_pos,:);predict_attr(train_neg,:);SV(L).attr];
        Train_label=[label_new;label_old];
        model_temp=libsvmtrain(Train_label,Train_attr,'-c 32 -g 0.01');
        sv_index=model_temp.sv_indices;        
        SV(L).total_nsv=model_temp.totalSV;
        SV(L).label=Train_label(sv_index);
        SV(L).attr=Train_attr(sv_index,:);
        SV(L).coef=model_temp.sv_coef;
        SV(L).rho=model_temp.rho;
    end    
end


end