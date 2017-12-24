%% ���ڼ���ʵ��3������Ӧ������������
clc;
clear;

%***************�޸Ĳ���*********************
file_Path='H:\��������\����ʵ��\zhj20170509\��������\';
featName='feature_DFT_MAV2';
simplemotionflag=0;%1����7�����飬0����14������
sample_size=444;
directionflag=1;%1������featSet������֤��-1����������֤
classify_kind='lda';%�����������࣬svm����lda
%****************************************************

featSet={'a1a2a3a4','b1b2b3b4','c1c2c3c4','d1d2d3d4','e1e2e3e4','f1f2f3f4',...
    'g1g2g3g4','h1h2h3h4','i1i2i3i4','j1j2j3j4','k1k2k3k4','l1l2l3l4',...
    'm1m2m3m4','n1n2n3n4','o1o2o3o4','p1p2p3p4','q1q2q3q4','r1r2r3r4',...
    's1s2s3s4','t1t2t3t4'};
%���������������֤���
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

%ѵ������
address_train=[file_Path,featName,'-',cell2mat(feat_train),'.mat'];
load(address_train);
%��һ������
y=featSaved(:,1:end-1);
y=real(y);
%*********�򵥶�����********
if simplemotionflag==1
    class_num=7;
    [y,y_label]=extract_SimpleMotion(y,featSaved(:,end));
    [y,~]=data_sort(y,y_label);%��������
else
    class_num=14;
    [y,~]=data_sort(y,featSaved(:,end));%��������
end
%***************************
[y,PS]=mapminmax(y',0,5);
trainData=y';%ѵ������
trainLabel=reshape(ones(sample_size,1)*(1:class_num),sample_size*class_num,1);

%ѵ��ģ��
if strcmp(classify_kind,'svm')
    model=libsvmtrain(trainLabel,trainData,'-c 32 -g 0.01');
elseif strcmp(classify_kind,'lda')
    model=fitcdiscr(trainData,trainLabel);
end

%�������ݲ���֤
label_out_total=[];
acc_total=[];
for i=1:length(feat_test)
    address_test=[file_Path,featName,'-',cell2mat(feat_test(i)),'.mat'];
    load(address_test);
    %��һ������
    y=featSaved(:,1:end-1);
    y=real(y);
    %*********�򵥶�����********
    if simplemotionflag==1
        class_num=7;
        [y,y_label]=extract_SimpleMotion(y,featSaved(:,end));
        [y,~]=data_sort(y,y_label);%��������
    else
        class_num=14;
        [y,~]=data_sort(y,featSaved(:,end));%��������
    end
    %***************************
    y=mapminmax('apply',y',PS);
    testData=y';%��������
    testLabel=reshape(ones(sample_size,1)*(1:class_num),sample_size*class_num,1);
    
    % ��֤
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

% ������
temp=strfind(file_Path,'\');
if strcmp(classify_kind,'svm')
    save([file_Path(temp(end-2)+1:temp(end-1)-1),'_SVM_NA_',featName(9:end),'_',...
        num2str(class_num),'_',num2str(directionflag),'.mat'],'label_out_total','acc_total');%������Ӧ����
elseif strcmp(classify_kind,'lda')
    save([file_Path(temp(end-2)+1:temp(end-1)-1),'_LDA_NA_',featName(9:end),'_',...
        num2str(class_num),'_',num2str(directionflag),'.mat'],'label_out_total','acc_total');%������Ӧ����    
end
disp('��֤����');
