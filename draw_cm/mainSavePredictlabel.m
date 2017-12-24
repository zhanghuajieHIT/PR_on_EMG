%% ��ȡ����DFT_MAV����������������ʶ����ȷ��
% ʶ����������.mat�ļ���
clc;
clear;

file1='H:\��������\fsr20170325';
file2='H:\��������\zhj20170322';
file3='H:\��������\scy20170323';
file5='H:\��������\xsp20170327';
file6='H:\��������\zgj20170324';
file7='H:\��������\zyh20170328';
fileSet={file1,file2,file3,file5,file6,file7};%û��wrj������
for iii=1:length(fileSet)
    file=cell2mat(fileSet(iii));
    % file='C:\Users\Robinson\Desktop\zhj\zgj20170324';
    floderPath=[file,'\�޹�һ��Ԥ�����overlapΪ128,lenΪ256'];
    fullPath = fullfile(floderPath,'*.mat');
    dirout=dir(fullPath);
    num=length(dirout);
    repeatNum=4;
    hand=2;
    funName={'feature_MAV'};
    FUN=funName;
    %% �������
    for start=1:hand %2��ָ�����ֶ��ɼ�����,������ֲɼ��Ļ����Ϊ1�����ֻ����Ҫһֻ�ֵ����ݣ�����start=1:2,���ǰ�hand=1
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            trainData=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%ȷ��ѵ��������             
            end
            dataName=cat(2,dataName,dataTrainName);%����ѵ�����������ݵ�����
            %��ȡ����������Ѿ���ȡ���ˣ���ֱ�Ӽ���
            load(cell2mat([file,'\��������\',FUN,'-',dataTrainName,'.mat']));
            trainData=cat(2,trainData,featSaved(:,1:end-1));
            train_label=featSaved(:,end);%label����һ����                                     
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%��һ��
    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%ȷ�����Լ�����
                end
                testData=[];
                if strcmp(dataTrainName,dataTestName)
                    continue;
                else
                    load(cell2mat([file,'\��������\',FUN,'-',dataTestName,'.mat']));
                    testData=cat(2,testData,featSaved(:,1:end-1));
                    test_label=featSaved(:,end);%label����һ���� 
                    testLabel=test_label;
                    testData=mapminmax(testData',0,5)';%��һ��
                end
                
                %% ��������
                [trainData,trainLabel]=data_sort(trainData,trainLabel);
                [testData,testLabel]=data_sort(testData,testLabel);

                %% �򵥶�����
%                 [trainData,trainLabel]=extract_SimpleMotion(trainData,trainLabel);
%                 [testData,testLabel]=extract_SimpleMotion(testData,testLabel); 
%                 trainData=mapminmax(trainData',0,5)';%��һ��
%                 testData=mapminmax(testData',0,5)';%��һ��
                

%% ����
                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                %����Ԥ����
                index=strfind(file,'\');
                evalin('base' ,[[file(index(end)+1:end),'.'],['predictLabel','_',dataTrainName,'_',dataTestName],'=predict_label']);
                evalin('base' ,[[file(index(end)+1:end),'.'],['acc','_',dataTrainName,'_',dataTestName],'=acc(1)']);
                save([file(index(end)+1:end),cell2mat(FUN),'.mat'],file(index(end)+1:end));
            end
        end

    end
  
end



