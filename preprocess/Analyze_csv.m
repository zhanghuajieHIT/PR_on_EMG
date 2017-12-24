function  [data] = Analyze_csv(file,channelNum,sampleNum)
%% input the file name of the data ,emg/acc/label are all ok
% 改进后的函数能够适用于实验动作顺序随机的情况
% 每个动作的数据没有额外增加

k = strfind( file,'emg');
if k >= 0
    fileemg = file;
    filelabel = strrep(file,'emg','label');
    fileacc = strrep(file,'emg','acc');
else
    k = strfind( file,'acc');
    if k >= 0
        fileacc = file;
        filelabel = strrep(file,'acc','label');
        fileemg = strrep(file,'acc','emg');
    else
        k = strfind( file,'label');
        if k >= 0
            filelabel = file;
            fileacc = strrep(file,'label','acc');
            fileemg = strrep(file,'label','emg');
        end
    end
end

if k > 0
    
    %get the channel of the input and output
    data.singalchannel  = csvread(filelabel,0,1,[0,1,0,1]);
    data.outputchannel  = csvread(filelabel,1,1,[1,1,1,1]);

    tmpdata = csvread(filelabel,4,0);
    tmpemg = csvread(fileemg, 4, 0);
    data.channellist = csvread(fileemg,3,1,[3,1,3,data.singalchannel]);
    % tmpacc = csvread(fileacc, 4, 0);

    % 实现unique的排序后原来数值的顺序不变
    [~,loc]=unique(tmpdata(:,2),'first');
    labelID=tmpdata((sort(loc)),2);
    
    label_num=unique(tmpdata(:,2));
%     minlabel = min(tmpdata(:,2));
%     maxlabel = max(tmpdata(:,2));
    data.sectionlist = [];
    for i = 1:length(label_num)
        data.section{i}.labelID = labelID(i);
%         index = find(tmpdata(:,2) == i);
        index = find(tmpdata(:,2) == data.section{i}.labelID );
        if(~isempty(index))
            data.sectionlist = [data.sectionlist i];           
            data.section{i}.label = tmpdata(index,[1,3 : 2 + data.outputchannel]);
            tmpdata(index,:) = [];  %删除index对应的数据
            startlabel =  data.section{i}.label(1,1);
            endlabel = data.section{i}.label(size(data.section{i}.label,1),1);			
           
            
%             startpoint = 1;%by zhj
            startpoint = startlabel;
% 			if(~isempty(tmpdata))	
% 				endpoint = find(tmpemg(:,1) <= round((endlabel + tmpdata(1,1)) * 0.5),1,'last');%在tmpemg中找到最后一个符合要求的数值的位置
                endpoint = endlabel;
                %除了第一组和最后一组外，其余组在前后各增加了约25ms的数据，但第一组数据是从头开始的，最后一组数据到最后，也增加了数据
% 			else
% 				endpoint = length(tmpemg(:,1));
% 			end
            index = [find(tmpemg(:,1)==startpoint) : find(tmpemg==endpoint)];
            data.section{i}.temp = tmpemg(index,2:(2+channelNum-1));
%             data.section{i}.emg =data.section{i}.temp(1:9630,:);%9630=5*1926
            data.section{i}.emg =data.section{i}.temp(1:sampleNum*0.05*1926,:);%14445=7.5*1926
%             tmpemg(index,:) = [];

        end
    end       
else
    error('Error: wrong filename');
end
