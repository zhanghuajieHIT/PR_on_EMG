%% ����ʵ��������ֵ����Ѱ��

clc;
clear;

global floderPath dataTrainName FUN referDataName
% referDataName='b1b2';
floderPath='C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
hand=2;
xlsFileName='C:\Users\zhj\Desktop\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300\ʵ���¼.xlsx';
experimentTime='zhj20170108';

% ���������Ľ�
% funName={'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC'};
funName={'feature_WAMP'};
%% �õ������������ά���Լ���ϵĸ���������
fun=Feat_Dim_Name(funName);

%% �������
featFusionNum=1;%��ϵ�������Ŀ
featFusion=nchoosek(fun,featFusionNum);%�������
featNum=size(featFusion,1);%������Ϻ�õ���������Ŀ

% ��ȡ����
for NUM=1:featNum
    [~,text]=xlsread(xlsFileName,experimentTime);
    row=size(text,1);
    featLoc=['A',num2str(row+1)];%����������xls�ļ��е�λ��
    featName={};
    featTotalCol= 0;
    for i=1:featFusionNum
       featName= cat(2,featName,featFusion{NUM,i}.name(9:end));
       featTotalCol= featTotalCol+featFusion{NUM,i}.featCol;
    end
    xlswrite(xlsFileName,featName,experimentTime,featLoc);%�����������������
    
    for start=1:hand %2��ָ�����ֶ��ɼ�����,������ֲɼ��Ļ����Ϊ1�����ֻ����Ҫһֻ�ֵ����ݣ�����start=1:2,���ǰ�hand=1
        Acc=[];%���ڱ�������
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%ȷ��ѵ��������             
            end
            dataName=cat(2,dataName,dataTrainName);%����ѵ�����������ݵ�����
            %��ȡ����������Ѿ���ȡ���ˣ���ֱ�Ӽ���
            trainData=[];
            for k=1:featFusionNum      
                FUN=featFusion{NUM,k}.name;
                if exist(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                    load(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat']);
                    trainData=cat(2,trainData,featSaved(:,1:end-1));
                    train_label=featSaved(:,end);%label����һ����
                else
                    [train_data,train_label]=loadData(floderPath,dataTrainName);
                    trainLen=size(train_data,3);
                    trainDataTemp=[];
                    % ��������¼�������������GA�Ż���ֵ
                    flag=0;
                    if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                            strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                        flag=1;
%                         thresh=GA_FeatPara;%GA�Ż�����ֵ����
%                         thresh=PSO_FeatPara;%PSO�Ż�����ֵ����
%                         evalin('base' ,['threshSaved.',FUN,'=thresh']);%����thresh�����Ӧ����������
%                         thresh=Para(train_data(:,:,1)');
                        for n=1:trainLen
                            thresh=Para(train_data(:,:,n)');
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
                        end           
                    else
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)'));
                        end        
                    end
                    trainData=cat(2,trainData,trainDataTemp);
                    if flag==0%����Ǽ�����ֵ�Ż������������ñ��档�������Ҫ����
                        featSaved=trainDataTemp;
                        featSaved=cat(2,featSaved,train_label);
                        save(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat'],'featSaved');
                    end    
                end                                                  
            end
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%��һ��
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%ȷ�����Լ�����
                end   
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k}.name;
                    if exist(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTestName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                        load(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTestName,'.mat']);
                        testData=cat(2,testData,featSaved(:,1:end-1));
                        test_label=featSaved(:,end);%label����һ���� 
                    else
                        [test_data,test_label]=loadData(floderPath,dataTestName);
                        testLen=size(test_data,3);
                        testDataTemp=[];
                        % ��������¼������������Ѿ��õ�����ֵ��ȡ������
                        flag=0;
                        if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                                strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                            flag=1;
%                             thresh=eval(['threshSaved.',FUN]);%��ȡ����Ķ�Ӧ��������ֵ
%                             thresh=Para(test_data(:,:,1)');
                            for n=1:testLen
                                thresh=Para(test_data(:,:,n)');
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                            end
                        else
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)'));
                            end
                        end
                        testData=cat(2,testData,testDataTemp);
                        if flag==0
                            featSaved=testDataTemp;
                            featSaved=cat(2,featSaved,test_label);
                            save(['C:\Users\zhj\Desktop\zhj20161219\��������\',FUN,'-',dataTestName,'.mat'],'featSaved');
                        end
                    end                                                   
                end
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%��һ��
                
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                Acc=cat(1,Acc,acc(1));
                
%             %% pca��ά
%                 trainDataPCA=PCA_opt(trainData,0.95);%ԭ���������İٷֱ�
%                 testDataPCA=PCA_opt(testData,0.95);
%                % ��һ����Ч������
%                 trainDataPCA=mapminmax(trainDataPCA',0,5)';
%                 testDataPCA=mapminmax(testDataPCA',0,5)';               
%                 model = libsvmtrain(trainLabel, trainDataPCA, '-c 32 -g 0.01');
%                 [predict_label, acc,~] = libsvmpredict(testLabel, testDataPCA, model);
%                 Acc=cat(1,Acc,acc(1));
        
            end
    
        end
        
        %% ���ݱ��浽xls�ļ���
        [~,text]=xlsread(xlsFileName,experimentTime);
        row=size(text,1);
        rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
        colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
        resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
        result=reshape(Acc,3,3)';
        xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
        xlswrite(xlsFileName,dataName',experimentTime,colLoc);
        xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

    end
    
end

fprintf('������ɣ�������������ȷ�ʾ�ֵ�����档\n');

%% �����ֵ������
% result=readData(experimentTime,xlsFileName);

fprintf('��ֵ������ɡ�\n');

