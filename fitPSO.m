function val=fitPSO(sol)
% PSO算法
global floderPath FUN dataTrainName
[data,label]=loadData(floderPath,dataTrainName);
featLen=size(data,3);
featData=zeros(featLen,8);    %注意特征的列数为8，不同的特征可能不一样
featLabel=label;
for ii=1:size(sol,1)
    thresh=sol(ii,:);
    for i=1:featLen
        featData(i,:)=feval(FUN,data(:,:,i)',thresh);
    end
    featData=mapminmax(featData',0,5)';%归一化

    %% 分类正确率作为适应度
    % 使用交叉验证的方法
    k=10;%5-flod
    totalNum=length(featData);
    num=fix(totalNum/k);
    index=randperm(totalNum);
    emgData=cell(1,k);
    emgLabel=cell(1,k);
    for i=1:k%数据随机分成k组
        emgData{i}=featData(index(1+(i-1)*num:num*i),:);
        emgLabel{i}=featLabel(index(1+(i-1)*num:num*i),:);
    end
    numIndex=1:k;
    result=[];
    for i=1:k
        testData=emgData{i};
        testLabel=emgLabel{i};
        temp=numIndex;
        temp(i)=[];
        trainData=[];
        trainLabel=[];
        for j=1:k-1
            trainData=cat(1,trainData,emgData{temp(j)});
            trainLabel=cat(1,trainLabel,emgLabel{temp(j)});
        end
    
        model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%可能需要用交叉验证调整
        [~, acc,~] = libsvmpredict(testLabel, testData, model);
        result=cat(1,result,acc(1));

    end
    val(ii)=1/mean(result);%求最小值
    
    
    
    %% Fisher比值
%     [~,ratioTotal]=FisherRatio(featData,featLabel);
%     val(ii)=1/ratioTotal;
end

end
