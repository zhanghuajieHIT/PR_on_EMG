clear;
clc;
close all;
% plot confusion matrix
% confusion matrix的每一行代表一类的分类信息
% mat 矩阵的每一行表示某一数据集作为训练集的测试正确率，即每一行的和为100%
classNum=14;
file1='H:\特征保存\fsr20170325';
file2='H:\特征保存\zhj20170322';
file3='H:\特征保存\scy20170323';
file5='H:\特征保存\xsp20170327';
file6='H:\特征保存\zgj20170324';
file7='H:\特征保存\zyh20170328';
fileSet={file1,file2,file3,file5,file6,file7};%没有wrj的数据
total_output=zeros(classNum,classNum);
for iii=1:length(fileSet)
    funName={'feature_DFT_MAV'};
    FUN=funName;
    total_output_erevyone=zeros(classNum,classNum);
    file=cell2mat(fileSet(iii));
    floderPath=[file,'\无归一化预处理后，overlap为128,len为256'];
    fullPath = fullfile(floderPath,'*.mat');
    index=strfind(file,'\');
    floderPath_mat=[file,'\','混淆矩阵数据\',file(index(end)+1:end),cell2mat(FUN),'.mat'];
    load(floderPath_mat);%需要先加载已经计算好的数据
    dirout=dir(fullPath);
    num=length(dirout);
    repeatNum=4;
    hand=2;
    feat_name_temp=cell2mat(FUN);
    %% 特征组合
    for start=1:hand %2是指左右手都采集数据,如果单手采集的话则改为1。如果只是需要一只手的数据，则是start=1:2,不是把hand=1
        dataName={};
        for i=((start-1)*repeatNum+1):(hand*repeatNum):num 
            dataTrainName=[];
            trainData=[];
            for k=0:repeatNum-1
                dataTrainName=strcat(dataTrainName,dirout(i+k).name(1:2));%确定训练集数据             
            end
            if strcmp(file(index(end)+1:end),'fsr20170325')&&(strcmp(dataTrainName,'e1e2e3e4')||strcmp(dataTrainName,'i1i2i3i4')||strcmp(dataTrainName,'h1h2h3h4'))
                continue;
            elseif strcmp(file(index(end)+1:end),'scy20170323')&&(strcmp(dataTrainName,'e1e2e3e4')||strcmp(dataTrainName,'g1g2g3g4'))
                continue;
            elseif strcmp(file(index(end)+1:end),'xsp20170327')&&(strcmp(dataTrainName,'k1k2k3k4')||strcmp(dataTrainName,'l1l2l3l4'))
                continue;
            elseif strcmp(file(index(end)+1:end),'zgj20170324')&&(strcmp(dataTrainName,'a1a2a3a4')||strcmp(dataTrainName,'l1l2l3l4'))
                continue;
            elseif strcmp(file(index(end)+1:end),'zhj20170322')&&(strcmp(dataTrainName,'k1k2k3k4'))
                continue;
            elseif strcmp(file(index(end)+1:end),'zyh20170328')&&(strcmp(dataTrainName,'a1a2a3a4'))
                continue;
            else
                dataName=cat(2,dataName,dataTrainName);%保存训练集所有数据的名称    
                for j=((start-1)*repeatNum+1):(hand*repeatNum):num
                    dataTestName=[];
                    for m=0:repeatNum-1
                        dataTestName=strcat(dataTestName,dirout(j+m).name(1:2));%确定测试集数据
                    end
                    if strcmp(dataTrainName,dataTestName)
                        continue;
                    elseif strcmp(file(index(end)+1:end),'fsr20170325')&&(strcmp(dataTrainName,'e1e2e3e4')||strcmp(dataTrainName,'i1i2i3i4')||strcmp(dataTrainName,'h1h2h3h4'))
                        continue;
                    elseif strcmp(file(index(end)+1:end),'scy20170323')&&(strcmp(dataTrainName,'e1e2e3e4')||strcmp(dataTrainName,'g1g2g3g4'))
                        continue;
                    elseif strcmp(file(index(end)+1:end),'xsp20170327')&&(strcmp(dataTrainName,'k1k2k3k4')||strcmp(dataTrainName,'l1l2l3l4'))
                        continue;
                    elseif strcmp(file(index(end)+1:end),'zgj20170324')&&(strcmp(dataTrainName,'a1a2a3a4')||strcmp(dataTrainName,'l1l2l3l4'))
                        continue;
                    elseif strcmp(file(index(end)+1:end),'zhj20170322')&&(strcmp(dataTrainName,'k1k2k3k4'))
                        continue;
                    elseif strcmp(file(index(end)+1:end),'zyh20170328')&&(strcmp(dataTrainName,'a1a2a3a4'))
                        continue;
                    else
                        predict_label=eval([[file(index(end)+1:end),'.'],['predictLabel','_',dataTrainName,'_',dataTestName]]);
                        target_label=(1:classNum)'*ones(1,length(predict_label)/classNum);
                        target_label=reshape(target_label',1,length(predict_label));
                        [~,output]=compute_cmData(target_label,predict_label');
                        total_output_erevyone=total_output_erevyone+output;
                    end
                end
            end
        end

    end
    %保存每一个人的数据
    save([file(index(end)+1:end),feat_name_temp(8:end),'_CM_output.mat'],'total_output_erevyone');
    %计算所有人的数据
    total_output=total_output+total_output_erevyone;
  
end
mat=total_output./(sum(total_output,2)*ones(1,size(total_output,2)));
% tick={'1','2','3','4','5','6','7','8','9','10','11','12','13','14'};
tick={'WE','WF','UD','RD','WP','WS','LG','SG','CG','TP','IP','HC','HO','HR'};
draw_cm(mat,tick,classNum)%画出混淆矩阵，tick表示种类名称
