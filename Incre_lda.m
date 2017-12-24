function [timing,label_out]=Incre_lda(address,Classifier_Pra,superviseflag,feat_train,feat_test,featName,simplemotionflag)
% 用于计算增量lda，包括有监督和无监督
class_num=Classifier_Pra.class_num;
sample_size=Classifier_Pra.sample_size;
sample_dim=Classifier_Pra.sample_dim;
twoclass_num=Classifier_Pra.twoclass_num;
twoclass_label=Classifier_Pra.twoclass_label;

Sample_attr=zeros(sample_size,sample_dim,class_num);
Session_count=length(feat_test);
label_out=zeros(sample_size*class_num,length(feat_train)*Session_count);
timing=zeros(sample_size*class_num,length(feat_train)*Session_count);
for ii=1:length(feat_train) %分别对左右手数据识别
    filename=strcat(address,featName,'-',cell2mat(feat_train(ii)),'.mat');
    load(filename);
    y=featSaved(:,1:end-1);
    y=real(y);
    %*********简单动作组***********
    if simplemotionflag==1
        [y,y_label]=extract_SimpleMotion(y,featSaved(:,end));%当然extract_SimpleMotion一个已经有排序的效果了
        [y,~]=data_sort(y,y_label);% 数据排序
    else
        [y,~]=data_sort(y,featSaved(:,end));% 数据排序
    end
    %******************************
    [y, PS]=mapminmax(y',0,5);
    y=y';
    Y_two=[ones(sample_size,1);-1*ones(sample_size,1)];
    for i=1:class_num
        for j=1:sample_size
            Sample_attr(j,:,i)=y(j+(i-1)*sample_size,1:sample_dim);
        end
    end
    
    for L=1:twoclass_num
        c1=twoclass_label(1,L);
        c2=twoclass_label(2,L);
        train_attr=[Sample_attr(:,:,c1);Sample_attr(:,:,c2)];
        model_temp=LDA_hq(train_attr,Y_two);
        LDA.Model{L}=model_temp;
        LDA.attr{L}=train_attr;
        LDA.label{L}= Y_two;
    end         
%     timing=zeros(sample_size*class_num*Session_count,1);
    compare_label=reshape(meshgrid(1:class_num,1:sample_size),class_num*sample_size,1);
%     sv_count=zeros(twoclass_num,sample_size*class_num*Session_count); 
    LDA_saved=LDA;
    %测试数据
    for jj=1:Session_count
%         LDA=LDA_saved;
        
%         label_out_temp=zeros(sample_size*class_num,Session_count);
        if size(cell2mat(feat_test(ii,jj)),2)==2   %判断是不是'[]'
            continue;
%             timing_total=cat(2,timing_total,timing);
%             label_out=cat(2,label_out,label_out_temp);
        else
            filename=strcat(address,featName,'-',feat_test{ii,jj},'.mat');
            load(filename);
            y=featSaved(:,1:end-1);
            y=real(y);
    %*********简单动作组***********
            if simplemotionflag==1
                [y,y_label]=extract_SimpleMotion(y,featSaved(:,end));%当然extract_SimpleMotion一个已经有排序的效果了
                [y,~]=data_sort(y,y_label);% 数据排序
            else
                [y,~]=data_sort(y,featSaved(:,end));% 数据排序
            end
    %******************************
            y=mapminmax('apply',y',PS);
            y=y';   
        
            for j=1:class_num
                for k=1:sample_size
                    tic;
                    ground_truth=compare_label((j-1)*sample_size+k);
                    predict_attr=y((j-1)*sample_size+k,:);
                    [LDA,label_out((j-1)*sample_size+k,(ii-1)*Session_count+jj)]=Incre_lda_update(LDA,Classifier_Pra,predict_attr,ground_truth,superviseflag);
                    timing((j-1)*sample_size+k,(ii-1)*Session_count+jj)=toc;
                    display(['class: ',num2str(j),'    session:',num2str((ii-1)*size(feat_test,2)+jj)]);
                end
            end
        end
%         timing_total=cat(2,timing_total,timing);
        
    end

end
