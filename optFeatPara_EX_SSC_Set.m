%% 用于实现特征阈值参数寻优

clc;
clear;

global floderPath dataTrainName dataTestName FUN

%7个人的数据
file1='C:\Users\dlr\Desktop\zhj\zhj20170322';
file2='C:\Users\dlr\Desktop\zhj\fsr20170325';
file3='C:\Users\dlr\Desktop\zhj\scy20170323';
file4='C:\Users\dlr\Desktop\zhj\wrj20170328';
file5='C:\Users\dlr\Desktop\zhj\xsp20170327';
file6='C:\Users\dlr\Desktop\zhj\zgj20170324';
file7='C:\Users\dlr\Desktop\zhj\zyh20170328';
fileSet={file1,file2,file3,file4,file5,file6,file7};

%特征
funName={'feature_SSC'};
FUN=cell2mat(funName);

%数据
trainName={'a1a2a3a4_k1k2k3k4','c1c2c3c4_k1k2k3k4','e1e2e3e4_k1k2k3k4','g1g2g3g4_k1k2k3k4','i1i2i3i4_k1k2k3k4','k1k2k3k4_a1a2a3a4'...%左手数据
   'b1b2b3b4_l1l2l3l4','d1d2d3d4_l1l2l3l4','f1f2f3f4_l1l2l3l4','h1h2h3h4_l1l2l3l4','j1j2j3j4_l1l2l3l4','l1l2l3l4_b1b2b3b4' };%右手数据


for iii=1:length(fileSet)
    file=cell2mat(fileSet(iii));
    iii
    floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];

    for jjj=1:12
        cell2mat_trainName=cell2mat(trainName(jjj));
        data_test_bound=strfind(cell2mat_trainName,'_');
        dataTrainName=cell2mat_trainName(1:data_test_bound-1);
        dataTestName=cell2mat_trainName(data_test_bound+1:end);
        
        % 判断是否已经存在该阈值
        if exist([file,'\',FUN,'-',dataTrainName,'-thresh.mat'],'file')
            continue;
        else
            thresh=PSO_FeatPara_EX;%PSO优化求阈值参数

            fullPath = fullfile(floderPath,'*.mat');
            dirout=dir(fullPath);
            num=length(dirout);
            repeatNum=4;

%% 得到组合特征的总维度以及组合的各特征名称
            fun=Feat_Dim_Name(funName);

%% 特征组合
            featFusionNum=1;%组合的特征数目
            featFusion=nchoosek(fun,featFusionNum);%排列组合
            featNum=size(featFusion,1);%进行组合后得到的特征数目

% 提取特征
            Acc=[];%用于保存数据
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];

% load([file,'\',FUN,'-',dataTrainName,'-thresh.mat']);

            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end           
            trainData=trainDataTemp;
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%归一化

            if jjj>=7
                start=2;%1表示左手，2表示右手
            else
                start=1;
            end

            hand=2;
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
                end   
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
    % 用已经得到的阈值提取特征。
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=testDataTemp;
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%归一化
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                Acc=cat(1,Acc,acc(1));
            end
            totalRight=sum(Acc)-max(Acc);
            save([file,'\',FUN,'-',dataTrainName,'-totalRight.mat'],'totalRight')
            save([file,'\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh')
        end

    end
end


