%% 实现特征降维

clc;
clear;

global floderPath dataTrainName FUN featDim GA_data GA_label featReduceDim PSO_data PSO_label
floderPath='H:\特征保存\zhj20161219\无归一化预处理后，overlap为100,len为300';
fullPath = fullfile(floderPath,'*.mat');
dirout=dir(fullPath);
num=length(dirout);
repeatNum=2;
hand=2;
featDim=8;
% 效果较好的所有特征
funName={'feature_DFT_MAV2','feature_DFT_WL','feature_MYOP','feature_WAMP'};
% funName={'feature_DFT_MAV2','feature_WT_MAV2','feature_WT_VORDER','feature_WPT_VAR'};
% funName={'feature_DFT_MAV2'};
%% 特征组合
featFusionNum=4;%组合的特征数目
featFusion=nchoosek(funName,featFusionNum);%排列组合
featNum=size(featFusion,1);%进行组合后得到的特征数目

% 提取特征
for NUM=1:featNum
result=[];
featName={};
for i=1:featFusionNum
    featName= cat(2,featName,featFusion{NUM,i}(9:end));
end
    
    for start=1:hand %2是指左右手都采集数据,如果单手采集的话则改为1。如果只是需要一只手的数据，则是start=1:2,不是把hand=1
        Acc=[];%用于保存数据
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%确定训练集数据             
            end
            dataName=cat(2,dataName,dataTrainName);%保存训练集所有数据的名称
            %提取特征，如果已经提取过了，则直接加载
            trainData=[];
            for k=1:featFusionNum
                FUN=featFusion{NUM,k};
%                 FUN=featFusion{NUM,k}.name;
                if exist(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat'],'file')%是否已经提取过该特征
                    load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat']);
                    trainData=cat(2,trainData,featSaved(:,1:end-1));
                    train_label=featSaved(:,end);%label都是一样的
                else
                    [train_data,train_label]=loadData(floderPath,dataTrainName);
                    trainLen=size(train_data,3);
                    trainDataTemp=[];
                    % 如果是以下几种特征，则用GA优化阈值
                    flag=0;
                    if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                            strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                        flag=1;
                        if ~exist(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'-thresh.mat'],'file')
%                             thresh=GA_FeatPara;%GA优化求阈值参数
                            thresh=PSO_FeatPara;%PSO优化求阈值参数
%                             evalin('base' ,['threshSaved.',FUN,'=thresh']);%保存thresh及其对应的特征名称
                            save(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'-thresh.mat'],'thresh');%保存阈值
                        else
                            load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);
                        end
                        for n=1:trainLen
                            trainDataTemp=cat(1,trainDataTemp,feval(FUN,train_data(:,:,n)',thresh));
                        end           
                    elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'等
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
                    if flag==0%如果是几种阈值优化的特征，则不用保存。别的特征要保存
                        featSaved=trainDataTemp;
                        featSaved=cat(2,featSaved,train_label);
                        save(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'.mat'],'featSaved');
                    end    
                end                                                  
            end
            trainLabel=train_label;
            trainData=mapminmax(trainData',0,5)';%归一化
            trainData=real(trainData);
            
%             for ii=1:size(trainData,1)
%                 trainData(ii,:)=trainData(ii,:)/(sum(trainData(ii,:).^2)).^0.5;
%             end
%             trainData=mapminmax(trainData',0,5)';%归一化
            %% PCA降维
%             no_dims = round(intrinsic_dim(trainData, 'EigValue'));
%             trainDataOri=[trainLabel,trainData];
%             [mappedX, mapping] = compute_mapping(trainDataOri, 'LDA',5);
%             trainData=mappedX;
            
%             [trainData,dim]=PCA_opt(trainData,0.95,8);%原数据能量的百分比
%             trainData=mapminmax(trainData',0,5)';%归一化
            
            %% 基于多准则融合降维
%             DIM=50;%降维到50
%             A_Relieff=FSReliefF(trainData,trainLabel);
%             A_Fisher=FisherRatio(trainData,trainLabel);
%             A_MDistance=MDistance(trainData,trainLabel);
%             fusionSort=A_Relieff+A_Fisher+A_MDistance;%融合的权值根据实际数据还有待改进
%             [~,newSort]=sort(fusionSort);%升序
%             trainData=trainData(:,newSort(1:DIM));
            
            %% 基于遗传算法的特征的特征降维
            featReduceDim=size(trainData,2);
            GA_data=trainData;
            GA_label=trainLabel;
            featIndex=GA_reduceDim;
            trainData=trainData(:,featIndex);%降维后的特征
            
            %% 基于PSO特征选择
%             featReduceDim=size(trainData,2);
%             PSO_data=trainData;
%             PSO_label=trainLabel;
%             featIndex=PSO_reduceDim;
%             trainData=trainData(:,featIndex);%降维后的特征

    
            for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                dataTestName=[];
                for m=0:repeatNum-1
                    dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
                end
                % 与训练集相同则不需要测试
                if strcmp(dataTestName,dataTrainName)
                    continue;
                end
                testData=[];
                for k=1:featFusionNum
                    FUN=featFusion{NUM,k};
%                     FUN=featFusion{NUM,k}.name;
                    if exist(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat'],'file')%是否已经提取过该特征
                        load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat']);
                        testData=cat(2,testData,featSaved(:,1:end-1));
                        test_label=featSaved(:,end);%label都是一样的 
                    else
                        [test_data,test_label]=loadData(floderPath,dataTestName);
                        testLen=size(test_data,3);
                        testDataTemp=[];
                        % 如果是以下几种特征，用已经得到的阈值提取特征。
                        flag=0;
                        if strcmp(FUN,'feature_ZC')||strcmp(FUN,'feature_MYOP')||...
                                strcmp(FUN,'feature_SSC')||strcmp(FUN,'feature_WAMP')
                            flag=1;
%                             thresh=eval(['threshSaved.',FUN]);%提取保存的对应特征的阈值
                            load(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTrainName,'-thresh.mat']);%就应该是dataTrainName
                            for n=1:testLen
                                testDataTemp=cat(1,testDataTemp,feval(FUN,test_data(:,:,n)',thresh));
                            end
                        elseif strfind(FUN,'_DFT')>0    %FUN='feature_DFT_MAV'等
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
                            save(['H:\特征保存\zhj20161219\特征保存\',FUN,'-',dataTestName,'.mat'],'featSaved');
                        end
                    end                                                   
                end
                testLabel=test_label;
                testData=mapminmax(testData',0,5)';%归一化
                testData=real(testData);
                
%                 for jj=1:size(testData,1)
%                     testData(jj,:)=testData(jj,:)/(sum(testData(jj,:).^2)).^0.5;
%                 end
%                 testData=mapminmax(testData',0,5)';%归一化
                %% PCA降维
%                 no_dims = round(intrinsic_dim(testData, 'EigValue'));
%                 testDataOri=[testLabel,testData];
%                 [mappedX, mapping] = compute_mapping(testData, 'LDA', 5);
%                 testData=mappedX;
                
%                 testData=PCA_opt(testData,0.95,dim);
%                 testData=mapminmax(testData',0,5)';%归一化
                
                %% 基于多准则融合降维
%                 testData=testData(:,newSort(1:DIM));
                
                %% 基于遗传算法特征降维
                testData=testData(:,featIndex);%降维后的特征
                
                %% 基于PSO特征选择
%                 testData=testData(:,featIndex);%降维后的特征

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
