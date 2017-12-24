function val=deCode(x)

global GA_data GA_label featReduceDim

featData=GA_data;
featLabel=GA_label;
x=x(:,1:featReduceDim);
[~,n]=find(x==1);

%% ������֤
k=10;%5-flod
totalNum=size(featData,1);
num=fix(totalNum/k);
index=randperm(totalNum);
emgData=cell(1,k);
emgLabel=cell(1,k);
for i=1:k%��������ֳ�k��
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
    %���ݽ�ά
    trainData=trainData(:,n);
    testData=testData(:,n);
    
    trainData=mapminmax(trainData',0,5)';
    testData=mapminmax(testData',0,5)';
    model = libsvmtrain(trainLabel, trainData, '-c 32 -g 0.01');%������Ҫ�ý�����֤����
    [~, acc,~] = libsvmpredict(testLabel, testData, model);
    result=cat(1,result,acc(1));

end
val=mean(result);



end


