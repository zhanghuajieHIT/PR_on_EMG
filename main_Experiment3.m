%% 用于计算实验3无自适应方法的主函数
clc;
clear;

%***************修改部分*********************
file_Path='H:\特征保存\长期实验\zhj20170509\特征保存\';
featName='feature_DFT_MAV2';
simplemotionflag=0;%1代表7动作组，0代表14动作组
sample_size=444;
directionflag=1;%1代表按照featSet正序验证，-1代表逆序验证
classify_kind='lda';%分类器的种类，svm或者lda
%****************************************************

featSet={'a1a2a3a4','b1b2b3b4','c1c2c3c4','d1d2d3d4','e1e2e3e4','f1f2f3f4',...
    'g1g2g3g4','h1h2h3h4','i1i2i3i4','j1j2j3j4','k1k2k3k4','l1l2l3l4',...
    'm1m2m3m4','n1n2n3n4','o1o2o3o4','p1p2p3p4','q1q2q3q4','r1r2r3r4',...
    's1s2s3s4','t1t2t3t4'};
%区分正序和逆序验证情况
if directionflag==1
    feat_train=featSet(1);
    feat_test=featSet(2:end);
elseif directionflag==-1
    feat_train=featSet(end);
    NUM=length(featSet);
    for i=NUM-1:-1:1
        feat_test(NUM-i)=featSet(i);
    end
end

%训练数据
address_train=[file_Path,featName,'-',cell2mat(feat_train),'.mat'];
load(address_train);
%归一化数据
y=featSaved(:,1:end-1);
y=real(y);
%*********简单动作组********
if simplemotionflag==1
    class_num=7;
    [y,y_label]=extract_SimpleMotion(y,featSaved(:,end));
    [y,~]=data_sort(y,y_label);%数据排序
else
    class_num=14;
    [y,~]=data_sort(y,featSaved(:,end));%数据排序
end
%***************************
[y,PS]=mapminmax(y',0,5);
trainData=y';%训练数据
trainLabel=reshape(ones(sample_size,1)*(1:class_num),sample_size*class_num,1);

%训练模型
if strcmp(classify_kind,'svm')
    model=libsvmtrain(trainLabel,trainData,'-c 32 -g 0.01');
elseif strcmp(classify_kind,'lda')
    model=fitcdiscr(trainData,trainLabel);
end

%测试数据并验证
label_out_total=[];
acc_total=[];
for i=1:length(feat_test)
    address_test=[file_Path,featName,'-',cell2mat(feat_test(i)),'.mat'];
    load(address_test);
    %归一化数据
    y=featSaved(:,1:end-1);
    y=real(y);
    %*********简单动作组********
    if simplemotionflag==1
        class_num=7;
        [y,y_label]=extract_SimpleMotion(y,featSaved(:,end));
        [y,~]=data_sort(y,y_label);%数据排序
    else
        class_num=14;
        [y,~]=data_sort(y,featSaved(:,end));%数据排序
    end
    %***************************
    y=mapminmax('apply',y',PS);
    testData=y';%测试数据
    testLabel=reshape(ones(sample_size,1)*(1:class_num),sample_size*class_num,1);
    
    % 验证
    if strcmp(classify_kind,'svm')
        [predict_label,acc,~]=libsvmpredict(testLabel,testData,model);
        label_out_total=cat(2,label_out_total,predict_label);
        acc_total=cat(2,acc_total,acc(1));
    elseif strcmp(classify_kind,'lda')
        predict_label=predict(model,testData);
        acc=length(find(predict_label==testLabel))/length(testLabel);
        label_out_total=cat(2,label_out_total,predict_label);
        acc_total=cat(2,acc_total,acc);
    end
end

% 保存结果
temp=strfind(file_Path,'\');
if strcmp(classify_kind,'svm')
    save([file_Path(temp(end-2)+1:temp(end-1)-1),'_SVM_NA_',featName(9:end),'_',...
        num2str(class_num),'_',num2str(directionflag),'.mat'],'label_out_total','acc_total');%无自适应策略
elseif strcmp(classify_kind,'lda')
    save([file_Path(temp(end-2)+1:temp(end-1)-1),'_LDA_NA_',featName(9:end),'_',...
        num2str(class_num),'_',num2str(directionflag),'.mat'],'label_out_total','acc_total');%无自适应策略    
end
disp('验证结束');
