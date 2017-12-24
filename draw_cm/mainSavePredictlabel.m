%% 求取基于DFT_MAV特征，各个动作的识别正确率
% 识别结果保存在.mat文件中
clc;
clear;

file1='H:\特征保存\fsr20170325';
file2='H:\特征保存\zhj20170322';
file3='H:\特征保存\scy20170323';
file5='H:\特征保存\xsp20170327';
file6='H:\特征保存\zgj20170324';
file7='H:\特征保存\zyh20170328';
fileSet={file1,file2,file3,file5,file6,file7};%没有wrj的数据
for iii=1:length(fileSet)
    file=cell2mat(fileSet(iii));
    % file='C:\Users\Robinson\Desktop\zhj\zgj20170324';
    floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
    fullPath = fullfile(floderPath,'*.mat');
    dirout=dir(fullPath);
    num=length(dirout);
    repeatNum=4;
    hand=2;
    funName={'feature_MAV'};
    FUN=funName;
    %% 特征组合
    for start=1:hand %2是指左右手都采集数据,如果单手采集的话则改为1。如果只是需要一只手的数据，则是start=1:2,不是把hand=1
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            trainData=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%确定训练集数据             
            end
            dataName=cat(2,dataName,dataTrainName);%保存训练集所有数据的名称
            %提取特征，如果已经提取过了，则直接加载
            load(cell2mat([file,'\特征保存\',FUN,'-',dataTrainName,'.mat']));
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label都是一样的                                     
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%归一化
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
                end
                testData=[];
                if strcmp(dataTrainName,dataTestName)
                    continue;
                else
                    load(cell2mat([file,'\特征保存\',FUN,'-',dataTestName,'.mat']));
                    testData=cat(2,testData,featSaved(:,1:end-1));
                    test_label=featSaved(:,end);%label都是一样的 
                    testLabel=test_label;
                    testData=mapminmax(testData',0,5)';%归一化
                end
                
                %% 数据排序
                [trainData,trainLabel]=data_sort(trainData,trainLabel);
                [testData,testLabel]=data_sort(testData,testLabel);

                %% 简单动作组
%                 [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
%                 [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
%                 trainData=mapminmax(trainData',0,5)';%归一化
%                 testData=mapminmax(testData',0,5)';%归一化
                

%% 分类
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                %保存预测结果
                index=strfind(file,'\');
                evalin('base' ,[[file(index(end)+1:end),'.'],['predictLabel','_',dataTrainName,'_',dataTestName],'=predict_label']);
                evalin('base' ,[[file(index(end)+1:end),'.'],['acc','_',dataTrainName,'_',dataTestName],'=acc(1)']);
                save([file(index(end)+1:end),cell2mat(FUN),'.mat'],file(index(end)+1:end));
            end
        end

    end
  
end



