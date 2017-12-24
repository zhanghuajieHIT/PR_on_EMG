function val=fitPSO_EX(sol)
% PSO算法
global floderPath FUN dataTrainName dataTestName
[data,label]=loadData(floderPath,dataTrainName);
featLen=size(data,3);
featData=zeros(featLen,8);    %注意特征的列数为8，不同的特征可能不一样
featLabel=label;

[dataTest,labelTest]=loadData(floderPath,dataTestName);
featDataTest=zeros(featLen,8); 
featLabelTest=labelTest;

for ii=1:size(sol,1)
    thresh=sol(ii,:);
    for i=1:featLen
        featData(i,:)=feval(FUN,data(:,:,i)',thresh);
    end
    featData=mapminmax(featData',0,5)';%归一化
    featData=real(featData);
    
    %测试数据
    for j=1:featLen
        featDataTest(j,:)=feval(FUN,dataTest(:,:,j)',thresh);
    end
    featDataTest=mapminmax(featDataTest',0,5)';
    featDataTest=real(featDataTest);

    %% 分类正确率作为适应度
    % 使用交叉验证的方法
%     k=5;%5-flod
%     totalNum=length(featData);
%     num=fix(totalNum/k);
%     index=randperm(totalNum);
%     emgData=cell(1,k);
%     emgLabel=cell(1,k);
%     for i=1:k%数据随机分成k组
%         emgData{i}=featData(index(1+(i-1)*num:num*i),:);
%         emgLabel{i}=featLabel(index(1+(i-1)*num:num*i),:);
%     end
%     numIndex=1:k;
%     result=[];
%     for i=1:k
%         testData=emgData{i};
%         testLabel=emgLabel{i};
%         temp=numIndex;
%         temp(i)=[];
%         trainData=[];
%         trainLabel=[];
%         for j=1:k-1
%             trainData=cat(1,trainData,emgData{temp(j)});
%             trainLabel=cat(1,trainLabel,emgLabel{temp(j)});
%         end
%     
%         model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%可能需要用交叉验证调整
%         [~, acc,~] = libsvmpredict(testLabel, testData, model);
%         result=cat(1,result,acc(1));
% 
%     end
%     val(ii)=1/mean(result);%求最小值
    
% libsvm自带
%     model=libsvmtrain(featLabel,featData,'-c 32 -g 0.01');
%     [~,acc,~]=libsvmpredict(featLabelTest,featDataTest,model);
%     val(ii)=1/acc(1);
%LDA
% model=fitcdiscr(featData,featLabel);
% predict_label=predict(model,featDataTest);
% acc=length(find(predict_label==featLabelTest))/length(featLabelTest);
% val(ii)=1/acc;

model=lda_train(featData,featLabel);
[predict_label,acc]=lda_test(model,featDataTest,featLabelTest);
val(ii)=1/acc;
    
%     result=libsvmtrain(featLabel,featData,['-c 32 -g 0.01 -v ',num2str(k)]);
%     val(ii)=1/result;
    %% Fisher比值
%     [~,ratioTotal]=FisherRatio(featData,featLabel);
%     val(ii)=1/ratioTotal;
end

end
