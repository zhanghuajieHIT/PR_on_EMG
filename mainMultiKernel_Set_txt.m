%% 多核SVM和不同核SVM的主函数
% 课题实验2的数据分类
clc;
clear;

file1='C:\Users\dlr\Desktop\zhj\zhj20170322';
file2='C:\Users\dlr\Desktop\zhj\fsr20170325';
file3='C:\Users\dlr\Desktop\zhj\scy20170323';
file4='C:\Users\dlr\Desktop\zhj\wrj20170328';
file5='C:\Users\dlr\Desktop\zhj\xsp20170327';
file6='C:\Users\dlr\Desktop\zhj\zgj20170324';
file7='C:\Users\dlr\Desktop\zhj\zyh20170328';
fileSet={file1,file2,file3,file4,file5,file6,file7};
for iii=1:length(fileSet)
    iii
    file=cell2mat(fileSet(iii));
    
floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=4;
% xlsFileName=[file,file(end-11:end),'.xlsx'];
% experimentTime='多核';%多核或者单核

FunName.a={'feature_MAV','feature_WL','feature_ZC','feature_SSC'};
FunName.b={'feature_RMS','feature_AR5'};
FunName.c={'feature_SE','feature_WL','feature_CC5','feature_AR5'};
FunName.d={'feature_WT_WL'};
FunName.e={'feature_DFT_MAV2'};
FunName.f={'feature_TDPSD'};
% FunName.g={'feature_DFT_MAV2','feature_DFT_DASDV','feature_WT_LOG','feature_WAMP'};
% FunName.g={'feature_DFT_MAV2','feature_DFT_WL','feature_MYOP','feature_WAMP',...
% 'feature_WT_MAV2','feature_WT_VORDER','feature_WPT_VAR','feature_DFT_DASDV','feature_WT_LOG'};

for featKindNum=97:102%+6
    funName=eval(['FunName.',char(featKindNum)]);
    fileID_feat=fopen([file,file(end-11:end),'_分类器比较.txt'],'a+');
    fprintf(fileID_feat,'%12s\n',['feature ',char(featKindNum)]);
    fclose(fileID_feat);
%% 把数据分为左手和右手
rowLeft=0;
rowRight=0;
leftDataName=cell(num/(2*repeatNum),1);
rightDataName=cell(num/(2*repeatNum),1);
for i=1:repeatNum:num
    if mod(i,2*repeatNum)==1
        rowLeft=rowLeft+1;
        for j=0:repeatNum-1
            leftDataName(rowLeft,1)=strcat(leftDataName(rowLeft,1),dirout(i+j).name(1:2));
        end
    else
        rowRight=rowRight+1;
        for j=0:repeatNum-1
            rightDataName(rowRight,1)=strcat(rightDataName(rowRight,1),dirout(i+j).name(1:2));
        end
    end
end

%% 左手数据为训练集，右手数据为测试集
allDataName=[leftDataName;rightDataName];

for k_num=1:3   %共3种多核
    Acc_Temp=[];
for i=1:length(allDataName)
    dataTrainName=cell2mat(allDataName(i));%确定训练数据
    trainData=[];
    for k=1:length(funName)%加载训练数据
        FUN=cell2mat(funName(k));
        if exist([file,'\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
            load([file,'\特征保存\',FUN,'-',dataTrainName,'.mat']);
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label都是一样的
        else
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];
            load([file,'\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end
            trainData=cat(2,trainData,trainDataTemp);
        end
    end
    trainLabel=train_label;
    trainData=real(trainData);
    trainData=mapminmax(trainData',0,5)';%归一化
    
    %% 确定测试数据并加载
    if i<=length(leftDataName)%确定测试数据
        startIndex=length(leftDataName)+1;
        endIndex=length(allDataName);
    else
        startIndex=1;
        endIndex=length(leftDataName);
    end
    for j=startIndex:endIndex
        dataTestName=cell2mat(allDataName(j));
        testData=[];
        for k=1:length(funName)%加载测试数据
            FUN=cell2mat(funName(k));
            if exist([file,'\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                load([file,'\特征保存\',FUN,'-',dataTestName,'.mat']);
                testData=cat(2,testData,featSaved(:,1:end-1));
                test_label=featSaved(:,end);%label都是一样的
            else
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
                load([file,'\特征保存\',FUN,'-',dataTestName,'-thresh.mat']);
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=cat(2,testData,testDataTemp);
            end
        end
        testLabel=test_label;
        testData=real(testData);
        testData=mapminmax(testData',0,5)';%归一化
        
        
        %% 分类
         %% 多核
         if k_num==1
            kernelType=cell(1,3);
            kernelType{1,1}='rbf';
            kernelType{1,2}='rq';
            kernelType{1,3}='expk';
         elseif k_num==2
             kernelType={'rbfExtend'};
         elseif k_num==3
             kernelType=cell(1,4);
             kernelType{1,1}='rbf';
             kernelType{1,2}='rbf2';
             kernelType{1,3}='rbf3';
             kernelType{1,4}='rbf4';
         end
        coef=ones(1,length(kernelType));
        [k_train,kernelTemp]=multiKernelFunc(trainData,[],[],coef,kernelType);
        [k_test,~]=multiKernelFunc(trainData,testData,kernelTemp,coef,kernelType);
%         
%         %% 分类
%          
        Ktrain=[(1:size(trainData,1))',k_train];
        model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
        Ktest=[(1:size(testData,1))',k_test];
        [predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);
        accuracy=acc(1);

        %% 保存所有的正确率
        Acc_Temp=cat(1,Acc_Temp,accuracy);%对应每个特征有72个数据
    end

end
        %% 数据保存到xls文件中
        if k_num==1
            dataName1={'rbf+rq+expk'};%
        elseif k_num==2
            dataName1={'rbfExtend'};
        elseif k_num==3
            dataName1={'rbfMultiscale'};
        end
       
                %% 数据保存在txt中
            result=reshape(Acc_Temp',6,12);%根据情况修改，最后形式为12*6
            fileID_classify = fopen([file,file(end-11:end),'_分类器比较.txt'],'a+');
            fprintf(fileID_classify,'%12s\n',cell2mat(dataName1));
            fprintf(fileID_classify,'%.2f %.2f %.2f %.2f %.2f %.2f\n',result);
            fclose(fileID_classify);
end

end

end
