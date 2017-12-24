clc;
clear;

%% ���������ݴ�excelת��mat�У����õ����ݱ�ΪNaN
[mkdata,mktxt]=xlsread('yangData.xlsx','fig8');
CA=zeros(6,40,1,72);
%ɾ������nan���к���
nanRow=find(isnan(mkdata(:,1)));
mkdata(nanRow,:)=[];
nanCol=find(isnan(mkdata(1,:)));
mkdata(:,nanCol)=[];

%% ������Ҫ����������Ϊnan
% ��Ҫ�޸ĵ�����
modify{1}.modifyPosRow_1=[3,5];
modify{1}.modifyPosCol_1=[3,5];
modify{1}.modifyPosRow_2=[4];
modify{1}.modifyPosCol_2=[4];

modify{2}.modifyPosRow_1=[3,4];
modify{2}.modifyPosCol_1=[3,4];
modify{2}.modifyPosRow_2=[];
modify{2}.modifyPosCol_2=[];

modify{3}.modifyPosRow_1=[5];
modify{3}.modifyPosCol_1=[5];
modify{3}.modifyPosRow_2=[5];
modify{3}.modifyPosCol_2=[5];

modify{4}.modifyPosRow_1=[1];
modify{4}.modifyPosCol_1=[1];
modify{4}.modifyPosRow_2=[5];
modify{4}.modifyPosCol_2=[5];

modify{5}.modifyPosRow_1=[5];
modify{5}.modifyPosCol_1=[5];
modify{5}.modifyPosRow_2=[];
modify{5}.modifyPosCol_2=[];

modify{6}.modifyPosRow_1=[1];
modify{6}.modifyPosCol_1=[1];
modify{6}.modifyPosRow_2=[];
modify{6}.modifyPosCol_2=[];

NUM=1;
for j=1:6:36
    for i=1:12:(size(mkdata,1))
        dataTemp_1=mkdata(i:i+5,j:j+5);
        dataTemp_2=mkdata(i+6:i+11,j:j+5);
        dataTemp_1(modify{NUM}.modifyPosRow_1,:)=nan;
        dataTemp_1(:,modify{NUM}.modifyPosCol_1)=nan;
        dataTemp_2(modify{NUM}.modifyPosRow_2,:)=nan;
        dataTemp_2(:,modify{NUM}.modifyPosCol_2)=nan;
        for k=1:6
            dataTemp_1(k,k)=nan;
            dataTemp_2(k,k)=nan;
        end
        mkdata(i:i+5,j:j+5)=dataTemp_1;
        mkdata(i+6:i+11,j:j+5)=dataTemp_2;
    end
    NUM=NUM+1;
end

peopleNo=1;
for j=1:6:36
    tempJ=j;
    for classifyNo=1:1   
        featNo=1;
        for i=1:12:(size(mkdata,1))
            temp=mkdata(i:i+11,tempJ:tempJ+5);
            CA(peopleNo,featNo,classifyNo,:)=reshape(temp',72,1);
            featNo=featNo+1;
        end
        tempJ=tempJ+6;
    end
    peopleNo=peopleNo+1;
end

save('CA_fig8.mat','CA');