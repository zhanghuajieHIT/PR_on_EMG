% 用于计算在第三部分中实验1,2，无自适应的正确率
% 用lda和svm
clc;
clear;

%***************修改部分*********************
featName='feature_DFT_MAV2';
simplemotionflag=1;%1代表7动作组，0代表14动作组
sample_size=444;
classify_kind='lda';%分类器的种类，svm或者lda
%****************************************************
address1='H:\特征保存\fsr20170325\特征保存\';
address2='H:\特征保存\scy20170323\特征保存\';
address3='H:\特征保存\xsp20170327\特征保存\';
address4='H:\特征保存\zgj20170324\特征保存\';
address5='H:\特征保存\zhj20170322\特征保存\';
address6='H:\特征保存\zyh20170328\特征保存\';
addressSet={address1,address2,address3,address4,address5,address6};

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


for i=1:length(addressSet)%有多少个人
    address=cell2mat(addressSet(i));
    featTrain=feat_train{1,i};
    label_out_total=[];
    acc_total=[];
    for ii=1:length(featTrain)%每个人的数据分为左右手
        address_train=[address,featName,'-',cell2mat(featTrain(ii)),'.mat'];
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
    
    
    %% 测试数据并验证
        featTest=feat_test{1,i};
        for j=1:length(featTest(ii,:))
            label_out=zeros(sample_size*class_num,1);%初始化
            acc=0;%初始化
            if size(cell2mat(featTest(ii,j)),2)==2
                label_out_total=cat(2,label_out_total,label_out);
                acc_total=cat(2,acc_total,acc);
            else
                address_test=[address,featName,'-',cell2mat(featTest(ii,j)),'.mat'];
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
    
    %% 验证
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
        end
    end
    %保存每个人的数据结果
    temp=strfind(address,'\');
    if strcmp(classify_kind,'svm')
        save([address(temp(end-2)+1:temp(end-1)-1),'_SVM_NA_',featName(9:end),'_',...
            num2str(class_num),'.mat'],'label_out_total','acc_total');%无自适应策略
    elseif strcmp(classify_kind,'lda')
        save([address(temp(end-2)+1:temp(end-1)-1),'_LDA_NA_',featName(9:end),'_',...
            num2str(class_num),'.mat'],'label_out_total','acc_total');%无自适应策略    
    end

end
disp('验证结束');
