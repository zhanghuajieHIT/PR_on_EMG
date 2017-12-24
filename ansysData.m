%% 用于分析数据
% 如：有些数据明显出错，可以将其剔除
% 可算平均值，方差

% 每次使用都需要根据需要的处理方式进行修改

%注意：实验1需要把对角线干掉，实验2不能把对角线干掉

clc;
clear;

%------------------修改区域————————————————%
file='H:\特征保存\zgj20170324\14\zgj20170324_14.xlsx';
sheet='阈值优化';

%剔除数据的位置
deleteRow_1=[1,6];
deleteCol_1=[1,6];
deleteRow_2=[5,6];
deleteCol_2=[5,6];

%---------------------------------------------%
%把txt中的数据保存在excel中
if strcmp('多核',sheet)
    [mkdata,mktxt]=xlsread(file,sheet);%查看execl中是否有数据
    if isempty(mkdata)
        pointIndex=strfind(file,'.');
        txtFile=[file(1:pointIndex(end)-1),'多核.txt'];
        [~,dataTxt] = multiKernelData_txt2mat(txtFile);
        xlswrite(file,dataTxt,sheet);
    end
end

if strcmp('所有特征',sheet)
    funName={'feature_MAV','feature_MAV1','feature_MAV2','feature_SSI','feature_RMS',...
    'feature_LOG','feature_WL','feature_DASDV','feature_VAR','feature_VORDER','feature_MDF',...
    'feature_SM3','feature_MDA','feature_WTM','feature_WTSVD','feature_WPTM','feature_WPTSVD'...
    'feature_BF_MAV','feature_BF_MAV1','feature_BF_MAV2','feature_BF_SSI','feature_BF_RMS',...
    'feature_BF_LOG','feature_BF_WL','feature_BF_DASDV','feature_BF_VAR','feature_BF_VORDER'...
    'feature_DFT_MAV','feature_DFT_MAV1','feature_DFT_MAV2','feature_DFT_SSI','feature_DFT_RMS',...
    'feature_DFT_LOG','feature_DFT_WL','feature_DFT_DASDV','feature_DFT_VAR','feature_DFT_VORDER'...
    'feature_WT_MAV','feature_WT_MAV1','feature_WT_MAV2','feature_WT_SSI','feature_WT_RMS',...
    'feature_WT_LOG','feature_WT_WL','feature_WT_DASDV','feature_WT_VAR','feature_WT_VORDER'...
    'feature_WPT_MAV','feature_WPT_MAV1','feature_WPT_MAV2','feature_WPT_SSI','feature_WPT_RMS',...
    'feature_WPT_LOG','feature_WPT_WL','feature_WPT_DASDV','feature_WPT_VAR','feature_WPT_VORDER'};
elseif strcmp('原始方法特征阈值',sheet)
    funName={'WAMP','ZC','MYOP','SSC'};
elseif strcmp('阈值优化',sheet)
    funName={'ZC','MYOP','WAMP','SSC'};
elseif strcmp('单核',sheet)
    funName={'lin','poly','sig','rq','logk','expk','inmk'};%没有rbf
elseif strcmp('多核',sheet)
    funName={'rbf+rq+expk','rbfExtend','rbfMultiscale'};%7动作和14动作的核函数不同
end

%注意：实验1需要把对角线数据干掉，实验2不能把对角线数据干掉
if strcmp('所有特征',sheet)||strcmp('阈值优化',sheet)||strcmp('原始方法特征阈值',sheet)
    exKind=1;
else
    exKind=2;   %1或者2
end

[dataTemp,text]=xlsread(file,sheet);
startCol=size(dataTemp,2)-6+1;
data=dataTemp(:,startCol:end);
aa=isnan(data(:,1));
data(aa,:)=[];
resultAver=[];
resultStd=[];
for i=1:size(data,1)/12
    data_1=data(1+(i-1)*12:1+(i-1)*12+5,:);
    data_2=data(1+(i-1)*12+6:1+(i-1)*12+6+5,:);
    % z如果是实验1，则对角线上的值置为0,data_1和data_2的格式一样
    if exKind==1
        for j=1:length(data_1)
            data_1(j,j)=0;
            data_2(j,j)=0;
        end
    end

    %% 将数据剔除
    if ~isempty(deleteRow_1)
        data_1(deleteRow_1,:)=[];
    end
    if ~isempty(deleteCol_1)
        data_1(:,deleteCol_1)=[];
    end
    if ~isempty(deleteRow_2)
        data_2(deleteRow_2,:)=[];
    end
    if ~isempty(deleteCol_2)
        data_2(:,deleteCol_2)=[];
    end
    %求出每小组的均值
    data_1_2=[reshape(data_1,size(data_1,1)*size(data_1,2),1);reshape(data_2,size(data_2,1)*size(data_2,2),1)];
    num=length(find(data_1_2));%得到结果不等于0的个数，及非对角线上的数据个数
    averNum=sum(sum(data_1_2))/num;%计算平均正确率
    %求出每小组的标准差（因为标准差的单位与均值的单位是一样的）,除以N-1
    stdNum=std(reshape(data_1_2,1,size(data_1_2,1)*size(data_1_2,2)));
    
    %保存均值和方差
    resultAver=cat(1,resultAver,averNum);
    resultStd=cat(1,resultStd,stdNum);
end

% 将数据保存在excel中

if isempty(text)
    rowLine=size(data,1);
else
    rowLine=length(text);
end
xlswrite(file,{'均值'},sheet,['A',num2str(rowLine+2)]);
xlswrite(file,{'标准差'},sheet,['B',num2str(rowLine+2)]);
xlswrite(file,roundn(resultAver,-2),sheet,['A',num2str(rowLine+3)]);%保存均值
xlswrite(file,roundn(resultStd,-2),sheet,['B',num2str(rowLine+3)]);%保存均值
if strcmp('所有特征',sheet)||strcmp('原始方法特征阈值',sheet)||strcmp('阈值优化',sheet)
    xlswrite(file,funName',sheet,['C',num2str(rowLine+3)]);%保存特征名称
elseif strcmp('单核',sheet)||strcmp('多核',sheet)
    funName=repmat(funName,1,6);
     xlswrite(file,funName',sheet,['C',num2str(rowLine+3)]);%保存特征名称
end
