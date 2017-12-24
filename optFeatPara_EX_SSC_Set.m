%% ����ʵ��������ֵ����Ѱ��

clc;
clear;

global floderPath dataTrainName dataTestName FUN

%7���˵�����
file1='C:\Users\dlr\Desktop\zhj\zhj20170322';
file2='C:\Users\dlr\Desktop\zhj\fsr20170325';
file3='C:\Users\dlr\Desktop\zhj\scy20170323';
file4='C:\Users\dlr\Desktop\zhj\wrj20170328';
file5='C:\Users\dlr\Desktop\zhj\xsp20170327';
file6='C:\Users\dlr\Desktop\zhj\zgj20170324';
file7='C:\Users\dlr\Desktop\zhj\zyh20170328';
fileSet={file1,file2,file3,file4,file5,file6,file7};

%����
funName={'feature_SSC'};
FUN=cell2mat(funName);

%����
trainName={'a1a2a3a4_k1k2k3k4','c1c2c3c4_k1k2k3k4','e1e2e3e4_k1k2k3k4','g1g2g3g4_k1k2k3k4','i1i2i3i4_k1k2k3k4','k1k2k3k4_a1a2a3a4'...%��������
   'b1b2b3b4_l1l2l3l4','d1d2d3d4_l1l2l3l4','f1f2f3f4_l1l2l3l4','h1h2h3h4_l1l2l3l4','j1j2j3j4_l1l2l3l4','l1l2l3l4_b1b2b3b4' };%��������


for iii=1:length(fileSet)
    file=cell2mat(fileSet(iii));
    iii
    floderPath=[file,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'];

    for jjj=1:12
        cell2mat_trainName=cell2mat(trainName(jjj));
        data_test_bound=strfind(cell2mat_trainName,'_');
        dataTrainName=cell2mat_trainName(1:data_test_bound-1);
        dataTestName=cell2mat_trainName(data_test_bound+1:end);
        
        % �ж��Ƿ��Ѿ����ڸ���ֵ
        if exist([file,'\',FUN,'-',dataTrainName,'-thresh.mat'],'file')
            continue;
        else
            thresh=PSO_FeatPara_EX;%PSO�Ż�����ֵ����

            fullPath = fullfile(floderPath,'*.mat');
            dirout=dir(fullPath);
            num=length(dirout);
            repeatNum=4;

%% �õ������������ά���Լ���ϵĸ���������
            fun=Feat_Dim_Name(funName);

%% �������
            featFusionNum=1;%��ϵ�������Ŀ
            featFusion=nchoosek(fun,featFusionNum);%�������
            featNum=size(featFusion,1);%������Ϻ�õ���������Ŀ

% ��ȡ����
            Acc=[];%���ڱ�������
            [train_data,train_label]=loadData(floderPath,dataTrainName);
            trainLen=size(train_data,3);
            trainDataTemp=[];

% load([file,'\',FUN,'-',dataTrainName,'-thresh.mat']);

            for n=1:trainLen
                trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
            end           
            trainData=trainDataTemp;
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%��һ��

            if jjj>=7
                start=2;%1��ʾ���֣�2��ʾ����
            else
                start=1;
            end

            hand=2;
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%ȷ�����Լ�����
                end   
                [test_data,test_label]=loadData(floderPath,dataTestName);
                testLen=size(test_data,3);
                testDataTemp=[];
    % ���Ѿ��õ�����ֵ��ȡ������
                for n=1:testLen
                    testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                end
                testData=testDataTemp;
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%��һ��
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


