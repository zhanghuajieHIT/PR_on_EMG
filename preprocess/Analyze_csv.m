function  [data] = Analyze_csv(file,channelNum,sampleNum)
%% input the file name of the data ,emg/acc/label are all ok
% �Ľ���ĺ����ܹ�������ʵ�鶯��˳����������
% ÿ������������û�ж�������

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

    % ʵ��unique�������ԭ����ֵ��˳�򲻱�
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
            tmpdata(index,:) = [];  %ɾ��index��Ӧ������
            startlabel =  data.section{i}.label(1,1);
            endlabel = data.section{i}.label(size(data.section{i}.label,1),1);			
           
            
%             startpoint = 1;%by zhj
            startpoint = startlabel;
% 			if(~isempty(tmpdata))	
% 				endpoint = find(tmpemg(:,1) <= round((endlabel + tmpdata(1,1)) * 0.5),1,'last');%��tmpemg���ҵ����һ������Ҫ�����ֵ��λ��
                endpoint = endlabel;
                %���˵�һ������һ���⣬��������ǰ���������Լ25ms�����ݣ�����һ�������Ǵ�ͷ��ʼ�ģ����һ�����ݵ����Ҳ����������
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
