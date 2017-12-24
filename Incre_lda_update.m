function [LDA,label_out]=Incre_lda_update(LDA,Classifier_Pra,predict_attr,ground_truth,supervise_flag)

% num_predict=size(predict_attr,1);
% class_num=Classifier_Pra.class_num;
twoclass_num=Classifier_Pra.twoclass_num;
twoclass_label=Classifier_Pra.twoclass_label;
% sigma=Classifier_Pra.sigma;
% C=Classifier_Pra.C;
% class_vote=zeros(num_predict,class_num);
% Make predictions
label_out=LDA_out_hq(LDA.Model,Classifier_Pra,predict_attr);

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
        label_old=LDA.label{L};
        Train_attr=[predict_attr(train_pos,:);predict_attr(train_neg,:);LDA.attr{L}];
        Train_label=[label_new;label_old];
%         model_temp=libsvmtrain(Train_label,Train_attr,'-c 32 -g 0.01');
        model_temp=LDA_hq(Train_attr,Train_label);
        LDA.Model{L}=model_temp;
%         sv_index=model_temp.sv_indices;        
%         LDA(L).total_nsv=model_temp.totalSV;
        LDA.label{L}=Train_label;
        LDA.attr{L}=Train_attr;
%         LDA(L).coef=model_temp.sv_coef;
%         LDA(L).rho=model_temp.rho;
    end    
    
end


end