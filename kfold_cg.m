%% k-fold
clc;
clear;
k=10;
data1=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\无归一化预处理后，overlap为100,len为300\a1.mat');
data2=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\无归一化预处理后，overlap为100,len为300\a2.mat');
data3=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\无归一化预处理后，overlap为100,len为300\a3.mat');
data4=load('E:\实验\Delsys数据采集\实验数据\14种动作模式\zhj20161123\无归一化预处理后，overlap为100,len为300\a4.mat');
data.DataStructure.rawEMG=cat(3,data1.DataStructure.rawEMG,data2.DataStructure.rawEMG,data3.DataStructure.rawEMG,data4.DataStructure.rawEMG);
label.DataStructure.labelID=cat(1,data1.DataStructure.labelID,data2.DataStructure.labelID,data3.DataStructure.labelID,data4.DataStructure.labelID);
label=label.DataStructure.labelID;

%% feature extrated  
len=size(data.DataStructure.rawEMG,3);
feature=zeros(len,8);
fun='feature_RMS';%可以修改提取特征的函数
for i=1:len
    feature(i,:)=feval(fun,data.DataStructure.rawEMG(:,:,i)');
end
%归一化
feature=mapminmax(feature',0,5)';
%分组
totalNum=length(feature);
num=fix(totalNum/k);%10-fold
index=randperm(totalNum);
emgData=cell(1,k);
emgLabel=cell(1,k);
for i=1:k
    emgData{i}=feature(index(1+(i-1)*num:num*i),:);
    emgLabel{i}=label(index(1+(i-1)*num:num*i),:);
end

%% classify
numIndex=1:k;
Acc=[];
for n=1:13
    for m=1:13
        result=[];
        para=['-c ',num2str(0.01*2^n),' -g ',num2str(0.01*2^m)];
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
            model = libsvmtrain(trainLabel, trainData, para);
            [predict_label, acc,~] = libsvmpredict(testLabel, testData, model);
            result=cat(1,result,acc(1));
        end
        Acc=cat(1,Acc,mean(result));
              
    end
    
end

%% 找出最大成功率的位置
[maxValue,loc]=max(Acc);
m=mod(loc,13);%13是根据m，n的范围进行修改
n=fix(loc/13);
c=num2str(0.01*2^n);
g=num2str(0.01*2^m);

