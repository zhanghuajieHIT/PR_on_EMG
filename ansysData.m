%% ���ڷ�������
% �磺��Щ�������Գ������Խ����޳�
% ����ƽ��ֵ������

% ÿ��ʹ�ö���Ҫ������Ҫ�Ĵ���ʽ�����޸�

%ע�⣺ʵ��1��Ҫ�ѶԽ��߸ɵ���ʵ��2���ܰѶԽ��߸ɵ�

clc;
clear;

%------------------�޸����򡪡�����������������������������%
file='H:\��������\zgj20170324\14\zgj20170324_14.xlsx';
sheet='��ֵ�Ż�';

%�޳����ݵ�λ��
deleteRow_1=[1,6];
deleteCol_1=[1,6];
deleteRow_2=[5,6];
deleteCol_2=[5,6];

%---------------------------------------------%
%��txt�е����ݱ�����excel��
if strcmp('���',sheet)
    [mkdata,mktxt]=xlsread(file,sheet);%�鿴execl���Ƿ�������
    if isempty(mkdata)
        pointIndex=strfind(file,'.');
        txtFile=[file(1:pointIndex(end)-1),'���.txt'];
        [~,dataTxt] = multiKernelData_txt2mat(txtFile);
        xlswrite(file,dataTxt,sheet);
    end
end

if strcmp('��������',sheet)
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
elseif strcmp('ԭʼ����������ֵ',sheet)
    funName={'WAMP','ZC','MYOP','SSC'};
elseif strcmp('��ֵ�Ż�',sheet)
    funName={'ZC','MYOP','WAMP','SSC'};
elseif strcmp('����',sheet)
    funName={'lin','poly','sig','rq','logk','expk','inmk'};%û��rbf
elseif strcmp('���',sheet)
    funName={'rbf+rq+expk','rbfExtend','rbfMultiscale'};%7������14�����ĺ˺�����ͬ
end

%ע�⣺ʵ��1��Ҫ�ѶԽ������ݸɵ���ʵ��2���ܰѶԽ������ݸɵ�
if strcmp('��������',sheet)||strcmp('��ֵ�Ż�',sheet)||strcmp('ԭʼ����������ֵ',sheet)
    exKind=1;
else
    exKind=2;   %1����2
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
    % z�����ʵ��1����Խ����ϵ�ֵ��Ϊ0,data_1��data_2�ĸ�ʽһ��
    if exKind==1
        for j=1:length(data_1)
            data_1(j,j)=0;
            data_2(j,j)=0;
        end
    end

    %% �������޳�
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
    %���ÿС��ľ�ֵ
    data_1_2=[reshape(data_1,size(data_1,1)*size(data_1,2),1);reshape(data_2,size(data_2,1)*size(data_2,2),1)];
    num=length(find(data_1_2));%�õ����������0�ĸ��������ǶԽ����ϵ����ݸ���
    averNum=sum(sum(data_1_2))/num;%����ƽ����ȷ��
    %���ÿС��ı�׼���Ϊ��׼��ĵ�λ���ֵ�ĵ�λ��һ���ģ�,����N-1
    stdNum=std(reshape(data_1_2,1,size(data_1_2,1)*size(data_1_2,2)));
    
    %�����ֵ�ͷ���
    resultAver=cat(1,resultAver,averNum);
    resultStd=cat(1,resultStd,stdNum);
end

% �����ݱ�����excel��

if isempty(text)
    rowLine=size(data,1);
else
    rowLine=length(text);
end
xlswrite(file,{'��ֵ'},sheet,['A',num2str(rowLine+2)]);
xlswrite(file,{'��׼��'},sheet,['B',num2str(rowLine+2)]);
xlswrite(file,roundn(resultAver,-2),sheet,['A',num2str(rowLine+3)]);%�����ֵ
xlswrite(file,roundn(resultStd,-2),sheet,['B',num2str(rowLine+3)]);%�����ֵ
if strcmp('��������',sheet)||strcmp('ԭʼ����������ֵ',sheet)||strcmp('��ֵ�Ż�',sheet)
    xlswrite(file,funName',sheet,['C',num2str(rowLine+3)]);%������������
elseif strcmp('����',sheet)||strcmp('���',sheet)
    funName=repmat(funName,1,6);
     xlswrite(file,funName',sheet,['C',num2str(rowLine+3)]);%������������
end
