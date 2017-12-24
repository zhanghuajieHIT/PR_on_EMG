% 传统无监督学习策略(增量学习)和有监督学习
% 包括lda和svm
% 其实就是将预测后验证数据作为训练集
clc;
clear;


%*************修改部分1*******************
for ex_Part=3:-1:2
    for simplemotionflag=0:1
for mm=1:2
    if mm==2
        classify_kind='lda';
    elseif mm==1
        classify_kind='svm';
    end

for kkk=1:2
    if kkk==2
        featName='feature_WT_WL';
    elseif kkk==1
        featName='feature_DFT_MAV2';
    end

superviseflag=0; % 1 代表有监督学习, -1 or 0 代表传统无监督学习
% simplemotionflag=0;% 1代表简单动作组即7种动作（1,2,5,6,12,13,14），0代表14种动作
Classifier_Pra.sample_size=444; % 每类的样本数
Classifier_Pra.sample_dim=48; % 样本维度
Classifier_Pra.sigma=sqrt(50);
% ex_Part=3;% 1或2代表实验1和实验2的数据，3代表长期实验的数据
% classify_kind='lda';
validation_way=1;%数据验证方法，分为1和2

if ex_Part==1||ex_Part==2
    address1='H:\特征保存\fsr20170325\特征保存\';
    
    ff
    address2='H:\特征保存\scy20170323\特征保存\';
    address3='H:\特征保存\xsp20170327\特征保存\';
    address4='H:\特征保存\zgj20170324\特征保存\';
    address5='H:\特征保存\zhj20170322\特征保存\';
    address6='H:\特征保存\zyh20170328\特征保存\';
    addressSet={address1,address2,address3,address4,address5,address6};
elseif ex_Part==3
    address1='H:\特征保存\长期实验\zhj20170508\特征保存\';
    address2='H:\特征保存\长期实验\zhj20170509\特征保存\';
    addressSet={address1,address2};
end
%*******************************************************
if ex_Part==1||ex_Part==2
    feat_train1={'a1a2a3a4';'b1b2b3b4'};
    feat_test1={'c1c2c3c4','[]','g1g2g3g4','[]','k1k2k3k4';...
        'd1d2d3d4','f1f2f3f4','[]','j1j2j3j4','l1l2l3l4'};
    feat_train2={'a1a2a3a4';'b1b2b3b4'};
    feat_test2={'c1c2c3c4','[]','[]','i1i2i3i4','k1k2k3k4';...
        'd1d2d3d4','f1f2f3f4','h1h2h3h4','j1j2j3j4','l1l2l3l4'};
    feat_train3={'a1a2a3a4';'b1b2b3b4'};
    feat_test3={'c1c2c3c4','e1e2e3e4','g1g2g3g4','i1i2i3i4','[]';...
        'd1d2d3d4','f1f2f3f4','h1h2h3h4','j1j2j3j4','[]'};
    feat_train4={'c1c2c3c4';'b1b2b3b4'};
    feat_test4={'[]','e1e2e3e4','g1g2g3g4','i1i2i3i4','k1k2k3k4';...
        'd1d2d3d4','f1f2f3f4','h1h2h3h4','j1j2j3j4','[]'};
    feat_train5={'a1a2a3a4';'b1b2b3b4'};
    feat_test5={'c1c2c3c4','e1e2e3e4','g1g2g3g4','i1i2i3i4','[]';...
        'd1d2d3d4','f1f2f3f4','h1h2h3h4','j1j2j3j4','l1l2l3l4'};
    feat_train6={'c1c2c3c4';'b1b2b3b4'};
    feat_test6={'[]','e1e2e3e4','g1g2g3g4','i1i2i3i4','k1k2k3k4';...
        'd1d2d3d4','f1f2f3f4','h1h2h3h4','j1j2j3j4','l1l2l3l4'};
    feat_train={feat_train1,feat_train2,feat_train3,feat_train4,feat_train5,feat_train6};
    feat_test={feat_test1,feat_test2,feat_test3,feat_test4,feat_test5,feat_test6};
elseif ex_Part==3
    feat_train1={'a1a2a3a4'};
    feat_test1={'b1b2b3b4','c1c2c3c4','d1d2d3d4','e1e2e3e4','f1f2f3f4','g1g2g3g4','h1h2h3h4',...
        'i1i2i3i4','j1j2j3j4','k1k2k3k4','l1l2l3l4','m1m2m3m4','n1n2n3n4','o1o2o3o4','p1p2p3p4',...
        'q1q2q3q4','r1r2r3r4','s1s2s3s4','t1t2t3t4'};  
    feat_train2={'a1a2a3a4'};
    feat_test2={'b1b2b3b4','c1c2c3c4','d1d2d3d4','e1e2e3e4','f1f2f3f4','g1g2g3g4','h1h2h3h4',...
        'i1i2i3i4','j1j2j3j4','k1k2k3k4','l1l2l3l4','m1m2m3m4','n1n2n3n4','o1o2o3o4','p1p2p3p4',...
        'q1q2q3q4','r1r2r3r4','s1s2s3s4','t1t2t3t4'};
    feat_train={feat_train1,feat_train2};
    feat_test={feat_test1,feat_test2};
end

if simplemotionflag==1
    Classifier_Pra.class_num=7; % 类别数目    
else
    Classifier_Pra.class_num=14; % 类别数目
end

% 1 vs 1 策略中需要的分类器模型数目
Classifier_Pra.twoclass_num=Classifier_Pra.class_num*(Classifier_Pra.class_num-1)/2;
% 1 vs 1 策略中对应的label
twoclass_label=zeros(2,Classifier_Pra.twoclass_num);
c1=1;
c2=1;
for L=1:Classifier_Pra.twoclass_num
    if c2<Classifier_Pra.class_num
        c2=c2+1;
    else
        c1=c1+1;
        c2=c1+1;
    end
    twoclass_label(1,L)=c1;
    twoclass_label(2,L)=c2;
end
Classifier_Pra.twoclass_label=twoclass_label;
label=reshape(ones(Classifier_Pra.sample_size,1)*(1:Classifier_Pra.class_num),Classifier_Pra.sample_size*Classifier_Pra.class_num,1);%期望标签

for i=1:length(addressSet)%总共有多少人
    address=cell2mat(addressSet(i));
    temp=strfind(address,'\');
    % 确定分类器
    if strcmp(classify_kind,'svm')
        [timing_total,label_out_total]=Incre_svm(address,Classifier_Pra,superviseflag,feat_train{1,i},feat_test{1,i},featName,simplemotionflag);
    elseif strcmp(classify_kind,'lda')
        [timing_total,label_out_total]=Incre_lda(address,Classifier_Pra,superviseflag,feat_train{1,i},feat_test{1,i},featName,simplemotionflag);    
    end
    
    acc=zeros(size(label_out_total,2),1);
    acc_total=[];
    for j=1:size(label_out_total,2)
        acc=length(find(label_out_total(:,j)==label))/length(label);%计算正确率
        acc_total=cat(2,acc_total,acc);
    end
    
    %保存数据
    if superviseflag==1
        save([address(temp(end-2)+1:temp(end-1)-1),'_increS',classify_kind,'-way',...
            num2str(validation_way),'-',featName(9:end),'-',num2str(Classifier_Pra.class_num),...
            '.mat'],'timing_total','label_out_total','acc_total');
    else
        save([address(temp(end-2)+1:temp(end-1)-1),'_increU',classify_kind,'-way',...
            num2str(validation_way),'-',featName(9:end),'-',num2str(Classifier_Pra.class_num),...
            '.mat'],'timing_total','label_out_total','acc_total');
    end   
    
end

end
end
    end
end