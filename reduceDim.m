%% ʵ��������ά

clc;
clear;

global floderPath dataTrainName FUN featDim GA_data GA_label featReduceDim PSO_data PSO_label
floderPath='H:\��������\zhj20161219\�޹�һ��Ԥ�����overlapΪ100,lenΪ300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
hand=2;
featDim=8;
% Ч���Ϻõ���������
funName={'feature_DFT_MAV2','feature_DFT_WL','feature_MYOP','feature_WAMP'};
% funName={'feature_DFT_MAV2','feature_WT_MAV2','feature_WT_VORDER','feature_WPT_VAR'};
% funName={'feature_DFT_MAV2'};
%% �������
featFusionNum=4;%��ϵ�������Ŀ
featFusion=nchoosek(funName,featFusionNum);%�������
featNum=size(featFusion,1);%������Ϻ�õ���������Ŀ

% ��ȡ����
for NUM=1:featNum
result=[];
featName={};
for i=1:featFusionNum
    featName= cat(2,featName,featFusion{NUM,i}(9:end));
end
    
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
                FUN=featFusion{NUM,k};
%                 FUN=featFusion{NUM,k}.name;
                if exist(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                    load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat']);
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
                        if ~exist(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'-thresh.mat'],'file')
%                             thresh=GA_FeatPara;%GA�Ż�����ֵ����
                            thresh=PSO_FeatPara;%PSO�Ż�����ֵ����
%                             evalin('base' ,['threshSaved.',FUN,'=thresh']);%����thresh�����Ӧ����������
                            save(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh');%������ֵ
                        else
                            load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'-thresh.mat']);
                        end
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
                        end           
                    elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'��
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_DFT(train_data(:,:,n)',FUN));
                        end
                    elseif strfind(FUN,'_WT')>0
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_WT(train_data(:,:,n)',FUN));
                        end
                    elseif strfind(FUN,'_WPT')>0
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_WPT(train_data(:,:,n)',FUN));
                        end
                    elseif strfind(FUN,'_BF')>0
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feature_BFeat(train_data(:,:,n)',FUN));
                        end
                    else
                        for n=1:trainLen 
                        trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)'));
                        end
                    end
%                     trainDataTemp=trainDataTemp./sum(trainDataTemp.^2)^0.5;
                    trainData=cat(2,trainData,trainDataTemp);
                    if flag==0%����Ǽ�����ֵ�Ż������������ñ��档�������Ҫ����
                        featSaved=trainDataTemp;
                        featSaved=cat(2,featSaved,train_label);
                        save(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'.mat'],'featSaved');
                    end    
                end                                                  
            end
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%��һ��
            trainData=real(trainData);
            
%             for ii=1:size(trainData,1)
%                 trainData(ii,:)=trainData(ii,:)/(sum(trainData(ii,:).^2)).^0.5;
%             end
%             trainData=mapminmax(trainData',0,5)';%��һ��
            %% PCA��ά
%             no_dims = round(intrinsic_dim(trainData, 'EigValue'));
%             trainDataOri=[trainLabel,trainData];
%             [mappedX, mapping] = compute_mapping(trainDataOri, 'LDA',5);
%             trainData=mappedX;
            
%             [trainData,dim]=PCA_opt(trainData,0.95,8);%ԭ���������İٷֱ�
%             trainData=mapminmax(trainData',0,5)';%��һ��
            
            %% ���ڶ�׼���ںϽ�ά
%             DIM=50;%��ά��50
%             A_Relieff=FSReliefF(trainData,trainLabel);
%             A_Fisher=FisherRatio(trainData,trainLabel);
%             A_MDistance=MDistance(trainData,trainLabel);
%             fusionSort=A_Relieff+A_Fisher+A_MDistance;%�ںϵ�Ȩֵ����ʵ�����ݻ��д��Ľ�
%             [~,newSort]=sort(fusionSort);%����
%             trainData=trainData(:,newSort(1:DIM));
            
            %% �����Ŵ��㷨��������������ά
            featReduceDim=size(trainData,2);
            GA_data=trainData;
            GA_label=trainLabel;
            featIndex=GA_reduceDim;
            trainData=trainData(:,featIndex);%��ά�������
            
            %% ����PSO����ѡ��
%             featReduceDim=size(trainData,2);
%             PSO_data=trainData;
%             PSO_label=trainLabel;
%             featIndex=PSO_reduceDim;
%             trainData=trainData(:,featIndex);%��ά�������

    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%ȷ�����Լ�����
                end
                % ��ѵ������ͬ����Ҫ����
                if strcmp(dataTestName,dataTrainName)
                    continue;
                end
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k};
%                     FUN=featFusion{NUM,k}.name;
                    if exist(['H:\��������\zhj20161219\��������\',FUN,'-',dataTestName,'.mat'],'file')%�Ƿ��Ѿ���ȡ��������
                        load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTestName,'.mat']);
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
                            load(['H:\��������\zhj20161219\��������\',FUN,'-',dataTrainName,'-thresh.mat']);%��Ӧ����dataTrainName
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                            end
                        elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'��
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_DFT(test_data(:,:,n)',FUN));
                            end
                        elseif strfind(FUN,'_WT')>0
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_WT(test_data(:,:,n)',FUN));
                            end
                        elseif strfind(FUN,'_WPT')>0
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_WPT(test_data(:,:,n)',FUN));
                            end
                        elseif strfind(FUN,'_BF')>0
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feature_BFeat(test_data(:,:,n)',FUN));
                            end
                        else
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)'));
                            end
                        end
%                         testDataTemp=testDataTemp./sum(testDataTemp.^2)^0.5;
                        testData=cat(2,testData,testDataTemp);
                        if flag==0
                            featSaved=testDataTemp;
                            featSaved=cat(2,featSaved,test_label);
                            save(['H:\��������\zhj20161219\��������\',FUN,'-',dataTestName,'.mat'],'featSaved');
                        end
                    end                                                   
                end
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%��һ��
                testData=real(testData);
                
%                 for jj=1:size(testData,1)
%                     testData(jj,:)=testData(jj,:)/(sum(testData(jj,:).^2)).^0.5;
%                 end
%                 testData=mapminmax(testData',0,5)';%��һ��
                %% PCA��ά
%                 no_dims = round(intrinsic_dim(testData, 'EigValue'));
%                 testDataOri=[testLabel,testData];
%                 [mappedX, mapping] = compute_mapping(testData, 'LDA', 5);
%                 testData=mappedX;
                
%                 testData=PCA_opt(testData,0.95,dim);
%                 testData=mapminmax(testData',0,5)';%��һ��
                
                %% ���ڶ�׼���ںϽ�ά
%                 testData=testData(:,newSort(1:DIM));
                
                %% �����Ŵ��㷨������ά
                testData=testData(:,featIndex);%��ά�������
                
                %% ����PSO����ѡ��
%                 testData=testData(:,featIndex);%��ά�������

                model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');
                [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
                Acc=cat(1,Acc,acc(1));
                
        
            end
    
        end
        
        result=cat(1,result,Acc);

    end

theAcc=mean(result);

end

% 	[X, labels] = generate_data('helix', 2000);
% 	figure, scatter3(X(:,1), X(:,2), X(:,3), 5, labels); title('Original dataset'), drawnow
% 	no_dims = round(intrinsic_dim(X, 'MLE'));
% 	disp(['MLE estimate of intrinsic dimensionality: ' num2str(no_dims)]);
% 	[mappedX, mapping] = compute_mapping(X, 'PCA', no_dims);	
% 	figure, scatter(mappedX(:,1), mappedX(:,2), 5, labels); title('Result of PCA');
%     [mappedX, mapping] = compute_mapping(X, 'Laplacian', no_dims, 7);	
% 	figure, scatter(mappedX(:,1), mappedX(:,2), 5, labels(mapping.conn_comp)); title('Result of Laplacian Eigenmaps'); drawnow
