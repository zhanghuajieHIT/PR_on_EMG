clc;
clear;

%% 将所有数据从excel转向mat中，不用的数据变为NaN
[mkdata,mktxt]=xlsread('yangData.xlsx','fig11的p7');
CA=zeros(6,4,5,72);
%删除所有nan的行和列
nanRow=find(isnan(mkdata(:,1)));
mkdata(nanRow,:)=[];
nanCol=find(isnan(mkdata(1,:)));
mkdata(:,nanCol)=[];

%% 将不需要的数据设置为nan
% 需要修改的数据
modify{1}.modifyPosRow_1=[];
modify{1}.modifyPosCol_1=[];
modify{1}.modifyPosRow_2=[];
modify{1}.modifyPosCol_2=[];

modify{2}.modifyPosRow_1=[3,4];
modify{2}.modifyPosCol_1=[];
modify{2}.modifyPosRow_2=[];
modify{2}.modifyPosCol_2=[3,4,9,10,15,16,21,22,27,28];

modify{3}.modifyPosRow_1=[6];
modify{3}.modifyPosCol_1=[6,12,18,24,30];
modify{3}.modifyPosRow_2=[6];
modify{3}.modifyPosCol_2=[6,12,18,24,30];

modify{4}.modifyPosRow_1=[1];
modify{4}.modifyPosCol_1=[1,7,13,19,25];
modify{4}.modifyPosRow_2=[1];
modify{4}.modifyPosCol_2=[1,7,13,19,25];

modify{5}.modifyPosRow_1=[];
modify{5}.modifyPosCol_1=[];
modify{5}.modifyPosRow_2=[6];
modify{5}.modifyPosCol_2=[6,12,18,24,30];

modify{6}.modifyPosRow_1=[];
modify{6}.modifyPosCol_1=[];
modify{6}.modifyPosRow_2=[];
modify{6}.modifyPosCol_2=[];

NUM=1;
for j=1:30:180
    for i=1:12:(size(mkdata,1))
        dataTemp_1=mkdata(i:i+5,j:j+29);
        dataTemp_2=mkdata(i+6:i+11,j:j+29);
        dataTemp_1(modify{NUM}.modifyPosRow_1,:)=nan;
        dataTemp_1(:,modify{NUM}.modifyPosCol_1)=nan;
        dataTemp_2(modify{NUM}.modifyPosRow_2,:)=nan;
        dataTemp_2(:,modify{NUM}.modifyPosCol_2)=nan;
        mkdata(i:i+5,j:j+29)=dataTemp_1;
        mkdata(i+6:i+11,j:j+29)=dataTemp_2;
    end
    NUM=NUM+1;
end

peopleNo=1;
for j=1:30:180
    tempJ=j;
    for classifyNo=1:5   
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

save('CA_fig11_7.mat','CA');