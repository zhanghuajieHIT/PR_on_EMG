%% Main function
clc;
clear; 
%% load data
floderPath='C:\Users\zhj\Desktop\zhj20161219\无归一化预处理后，overlap为100,len为300';
dataName_train='a1a2';
dataName_test='b1b2';
[trainDataTemp,trainLabelTemp]=loadData(floderPath,dataName_train);
[testDataTemp,testLabelTemp]=loadData(floderPath,dataName_test);
%% feature extrated  
fun='feature_gnDFTR';%可以修改提取特征的函数
% WTNameTotal={'db2','db3','db4','db5','sym2','sym3','sym4','sym5','coif2',...
%     'coif3','coif4','coif5','dmey','bior1.1','bior1.3','bior1.5','bior2.2',...
%     'bior2.4','bior2.6','bior2.8','bior3.1','bior3.3','bior3.5','bior3.7',...
%     'bior3.9','bior4.4','bior5.5','bior6.8'};
% WTNameTotal={'db2'};
% result=[];
% for ii=1:length(WTNameTotal)
%     WTName=WTNameTotal{ii};
trainData=[];
testData=[];
trainLen=size(trainDataTemp,3);
% trainData=zeros(trainLen,48);%注意特征的列数为8，不同的特征可能不一样
testLen=size(testDataTemp,3);
% testData=zeros(testLen,48);
% trainData(1,1:8)=feature_RMS(train.DataStructure.rawEMG(:,:,1)');%针对DRMS2特征
for i=1:trainLen
%     trainTemp=remSamp(train.DataStructure.rawEMG(:,:,i)');
%     trainData(i,:)=feval(fun,trainTemp);

%     dftx=DFT(trainDataTemp(:,:,i)');
%     trainData(i,:)=feature_DFT(dftx,fun);

    trainData(i,:)=feval(fun,trainDataTemp(:,:,i)');

%     trainData=cat(1,trainData,feature_WT(trainDataTemp(:,:,i)',fun,WTName));
%     trainData(i,:)=feval(fun,train.DataStructure.rawEMG(:,:,i)',trainData(i-1,:));%针对DRMS2特征
%     trainData(i,:)=feature_RMS(train.DataStructure{1, 1}.rawEMG(:,:,i)');
%     trainData(i,:)=feval(f,train.DataStructure.rawEMG(:,:,i)');
end

trainLabel=trainLabelTemp;
trainData=mapminmax(trainData',0,5)';%归一化

% testData(1,1:8)=feature_RMS(test.DataStructure.rawEMG(:,:,1)');%针对DRMS2特征
for i=1:testLen
%     testTemp=remSamp(test.DataStructure.rawEMG(:,:,i)');
%     testData(i,:)=feval(fun,testTemp);   
    
    testData(i,:)=feval(fun,testDataTemp(:,:,i)');
    
%     testData=cat(1,testData,feature_WT(testDataTemp(:,:,i)',fun,WTName));

%     testData(i,:)=feval(fun,test.DataStructure.rawEMG(:,:,i)',testData(i-1,:));%针对DRMS2特征
%     testData(i,:)=feature_RMS(test.DataStructure{1, 3}.rawEMG(:,:,i)');
%     testData(i,:)=feval(f,test.DataStructure.rawEMG(:,:,i)');
end

testLabel=testLabelTemp;
testData=mapminmax(testData',0,5)';%归一化


% SVMStruct=fitcecoc(trainData,trainLabel);%SVM分多类
% predict_label=predict(SVMStruct,testData);

%% 不同类型的分类器
%-----------------------------------------------------------------------
% t=templateSVM('KernelFunction','linear');
% M=fitcecoc(trainData,trainLabel,'Learners',t);%SVM分多类
%-----------------------------------------------------------------------
% M=fitcdiscr(trainData,trainLabel,'discrimType','linear');%判别分析LDA
%-----------------------------------------------------------------------
% M=fitcknn(trainData,trainLabel,'NumNeighbors',4);%KNN
%-----------------------------------------------------------------------
% M=TreeBagger(100,trainData,trainLabel);%随机森林
% predict_label=predict(M,testData);
% count=0;
% for ii=1:length(predict_label)
%    if(str2num(predict_label{ii})==testLabel(ii))
%        count=count+1;
%    end
% end
% accuracy=count/length(testLabel)*100
%-------------------------------------------------------------------------
% M=fitcnb(trainData,trainLabel);%Naive Bayes
%----------------------------------------------------------------------
% M=fitensemble(trainData,trainLabel,'Bag',10,'Discriminant','type','classification');%集成学习
%------------------------------------------------------------------------
% predict_label=predict(M,testData);
% accuracy= length(find(predict_label == testLabel))/length(testLabel)*100
%---------------ANN-------------------------------------------------------
% train_data=trainData';
% train_label=trainLabel';
% % train_label=ind2vec(train_label);
% test_data=testData';
% test_label=testLabel';
% % net=newff(minmax(train_data),[20,14],{'tansig','tansig'},'trainrp');%BP
% % net=newrbe(train_data,train_label,1.5);%RBF神经网络
% % net=newc(minmax(train_data),14,0.1);%自组织竞争网络
% % net=newsom(minmax(train_data));%SMO网络
% 
% % net.trainParam.show=50;
% % net.trainParam.lr=0.1;
% net.trainParam.epochs=50;
% % net.trainParam.goal=0.5e-3;
% net=train(net,train_data);
% output=sim(net,train_data);
% % for i=1:length(test_label)
% %     [~,predictTemp]=sort(output);
% %     predictLabel(i)=predictTemp(14);
% % end
% % temp=mean(output);
% % accuracy= length(find(predictLabel == test_label))/length(testLabel)*100
%----LVQ-------------
% train_data=trainData';
% train_label=trainLabel';
% train_label=ind2vec(train_label);
% test_data=testData';
% test_label=testLabel';
% % net=newff(train_data,train_label,8);
% net=newlvq(minmax(train_data),20,ones(1,14)*(1/14));
% net.trainParam.epochs=1000;
% net.trainParam.show=10;
% net.trainParam.lr=0.1;
% net.trainParam.goal=0.1;
% net=train(net,train_data,train_label);
% predict_label=sim(net,test_data);
% predictLabel=vec2ind(predict_label);
% accuracy= length(find(predictLabel == test_label))/length(testLabel)*100
%----概率神经网络----------------------------------------------
% train_data=trainData';
% train_label=trainLabel';
% train_label=ind2vec(train_label);
% test_data=testData';
% test_label=testLabel';
% net=newpnn(train_data,train_label,4);
% predict_label=sim(net,test_data);
% predictLabel=vec2ind(predict_label);
% accuracy= length(find(predictLabel == test_label))/length(testLabel)*100
%% adaboost方法
% Acc=adaboost(trainData,trainLabel,testData,testLabel)
%% 1vs1分类
% aa=twoClassSVM(trainData,trainLabel,testData,testLabel);
%% classify
% result=[];
% for m=1:13
%     for n=1:13
%          para=['-c ',num2str(0.01*2^n),' -g ',num2str(0.01*2^m)];
%          model = libsvmtrain(trainLabel, trainData, para);

    
         k_train=kernelFunc(trainData,'sig',[0.01,1]);
%          [k_train,kernelTemp]=multiKernelFunc(trainData,[],[],[0,1]);
         Ktrain=[(1:size(trainData,1))',k_train];
         model=libsvmtrain(trainLabel, Ktrain, '-t 4 -c 32');
         k_test=kernelFunc(trainData,'sig',[0.01,1],testData);
%          [k_test,~]=multiKernelFunc(trainData,testData,kernelTemp,[0,1]);
         Ktest=[(1:size(testData,1))',k_test];
         [predict_label, acc,~] = libsvmpredict(testLabel, Ktest, model);

%       [~,c,g]=girdsearch_SVM(trainData,trainLabel);
%       cmd=['-c ',num2str(32),' -t 2 ',' -g ',num2str(0.01)];
%          model = libsvmtrain(trainLabel, trainData, cmd);
%          [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
%          result=cat(1,result,acc(1));

%     end
% end
% [maxValue,loc]=max(result);
% m=mod(loc,13);%13是根据m，n的范围进行修改
% n=fix(loc/13);
% c=num2str(0.01*2^n);
% g=num2str(0.01*2^m);


% end


