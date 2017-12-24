%% ʵ���Զ������е����ݽ��н���ѵ������֤������������浽xls�ļ���
% �����еĵ��������ֱ���м��㣬ע���ǵ�������
% ע��ʵ�������Ҫ�޸ĵĲ������£�
% fun,floderPath,repeatNum,xlsFileName,experimentTime,start,hand,featCol


clear;
clc;

floderPath='E:\ʵ��\Delsys���ݲɼ�\ʵ������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
hand=2;
xlsFileName='E:\ʵ��\Delsys���ݲɼ�\ʵ���¼\ʵ���¼.xlsx';
experimentTime='zhj20161219';

% funName={'feature_IEMG','feature_MAV','feature_MAV1','feature_MAV2','feature_SSI',...
%     'feature_VAR','feature_MAVTM3','feature_MAVTM4','feature_MAVTM5','feature_RMS',...
%     'feature_VORDER','feature_LOG','feature_WL','feature_AAC','feature_DASDV',...
%     'feature_ZC','feature_MYOP','feature_WAMP','feature_SSC','feature_MHW','feature_MTW',...
%     'feature_HIST','feature_AR','feature_CC','feature_ApEn','feature_SampEn',...
%     'feature_MAVS','feature_Kurt','feature_Skew','feature_AFB','feature_MNF',...
%     'feature_MDF','feature_PKF','feature_MNP','feature_TTP','feature_SMN1','feature_SMN2',...
%     'feature_SMN3','feature_FR','feature_PSR','feature_VCF','feature_MFMD','feature_MFMN',...
%     'feature_WCE','feature_WCM','feature_WCSVD','feature_WPCE','feature_WPCM','feature_WPCSVD'};

% new feature
% funName={'feature_DRMS','feature_DRMS2','feature_MRMS','feature_MVC','feature_Range','feature_RConv1','feature_RConv2'};

funName={'feature_MAV','feature_RMS','feature_WL','feature_SSC','feature_ZC',...
    'feature_MYOP','feature_WAMP','feature_DASDV','feature_WCM','feature_WCSVD',...
    'feature_WPCM','feature_WPCSVD'};

funNum=length(funName);
for N=1:funNum
    fun=funName{N};
    if strcmp(fun,'feature_WCE')||strcmp(fun,'feature_WCM')||strcmp(fun,'feature_WCSVD')
       featCol=48; 
    elseif strcmp(fun,'feature_WPCE')||strcmp(fun,'feature_WPCM')||strcmp(fun,'feature_WPCSVD')
        featCol=64;
    elseif strcmp(fun,'feature_HIST')
        featCol=72;
    elseif strcmp(fun,'feature_AR')||strcmp(fun,'feature_CC')
        featCol=40;
    elseif strcmp(fun,'feature_MAVS')
        featCol=7;
    elseif strcmp(fun,'feature_DRMS')
        featCol=15;
    elseif strcmp(fun,'feature_DRMS2')
        featCol=16;
    else
        featCol=8;%����������
    end
    
[~,text]=xlsread(xlsFileName,experimentTime);
row=size(text,1);
featLoc=['A',num2str(row+1)];%����������xls�ļ��е�λ��
featName={fun(9:end)};
xlswrite(xlsFileName,featName,experimentTime,featLoc);%������������


for start=1:hand %2��ָ�����ֶ��ɼ�����,������ֲɼ��Ļ����Ϊ1
    Acc=[];%���ڱ�������
    dataName={};
%     train.DataStructure.rawEMG=[];
    
for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
    train.DataStructure.rawEMG=[];
    train.DataStructure.labelID=[];
    dataNameTemp=[];
    for k=0:repeatNum-1
        trainTemp=load(fullfile(floderPath,dirout(i+k).name));
        train.DataStructure.rawEMG=cat(3,train.DataStructure.rawEMG,trainTemp.DataStructure.rawEMG);
        train.DataStructure.labelID=cat(1,train.DataStructure.labelID,trainTemp.DataStructure.labelID);
        dataNameTemp=strcat(dataNameTemp,dirout(i+k).name(1:2));
    end
    dataName=cat(2,dataName,dataNameTemp);
    
    for j=((start-1)*repeatNum+1):(hand*repeatNum):num
        test.DataStructure.rawEMG=[];
        test.DataStructure.labelID=[];
        for m=0:repeatNum-1
            testTemp=load(fullfile(floderPath,dirout(j+m).name));
            test.DataStructure.rawEMG=cat(3,test.DataStructure.rawEMG,testTemp.DataStructure.rawEMG);
            test.DataStructure.labelID=cat(1,test.DataStructure.labelID,testTemp.DataStructure.labelID);
        end               
        
        trainLen=size(train.DataStructure.rawEMG,3);
        trainData=zeros(trainLen,featCol);    %ע������������,��ͬ���������ܲ�һ��
        testLen=size(test.DataStructure.rawEMG,3);
        testData=zeros(testLen,featCol);
        
        for n=1:trainLen
            trainData(n,:)=feval(fun,train.DataStructure.rawEMG(:,:,n)');
        end
        trainLabel=train.DataStructure.labelID;
        trainData=mapminmax(trainData',0,5)';%��һ��
        
        for n=1:testLen
           testData(n,:)=feval(fun,test.DataStructure.rawEMG(:,:,n)'); 
        end
        testLabel=test.DataStructure.labelID;
        testData=mapminmax(testData',0,5)';%��һ��
        model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
        [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
        Acc=cat(1,Acc,acc(1));
        
    end
    
end

% %% ���ݱ��浽xls�ļ���
%     [~,text]=xlsread(xlsFileName,experimentTime);
%     row=size(text,1);
%     rowLoc=['C',num2str(row+1),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+1)];
%     colLoc=['B',num2str(row+2),':','B',num2str(row+2+num/(2*repeatNum)-1)];%num/(2*repeatNum)-1
%     resultLoc=['C',num2str(row+2),':',char(double('C')+num/(2*repeatNum)-1),num2str(row+2+num/(2*repeatNum)-1)];
%     result=reshape(Acc,3,3)';
%     xlswrite(xlsFileName,dataName,experimentTime,rowLoc);
%     xlswrite(xlsFileName,dataName',experimentTime,colLoc);
%     xlswrite(xlsFileName,roundn(result,-2),experimentTime,resultLoc);

end

end

% fprintf('������ɣ�������������ȷ�ʾ�ֵ�����档\n');

%% �����ֵ������
% result=readData(experimentTime,xlsFileName);
