function  [data] = Analyze_csv(file)
%% input the file name of the data ,emg/acc/label are all ok


k = strfind( file,'-emg-');
if k >= 0
    fileemg = file;
    filelabel = strrep(file,'-emg-','-label-');
    fileacc = strrep(file,'-emg-','-acc-');
else
    k = strfind( file,'-acc-');
    if k >= 0
        fileacc = file;
        filelabel = strrep(file,'-acc-','-label-');
        fileemg = strrep(file,'-acc-','-emg-');
    else
        k = strfind( file,'-label-');
        if k >= 0
            filelabel = file;
            fileacc = strrep(file,'-label-','-acc-');
            fileemg = strrep(file,'-label-','-emg-');
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
    tmpacc = csvread(fileacc, 4, 0);
    
    minlabel = min(tmpdata(:,2));
    maxlabel = max(tmpdata(:,2));
    data.sectionlist = [];
    for i = minlabel : maxlabel
        index = find(tmpdata(:,2) == i);
        if(~isempty(index))
            data.sectionlist = [data.sectionlist i];
            
            data.section{i + 1}.label = tmpdata(index,[1,3 : 2 + data.outputchannel]);
            tmpdata(index,:) = [];
            startlabel =  data.section{i + 1}.label(1,1) - 1000;
            endlabel = data.section{i + 1}.label(size(data.section{i + 1}.label,1),1) + 1000;

            startpoint = tmpemg(1,1);
            endpoint = tmpemg(size(tmpemg,1),1);
            startpoint = find(tmpemg(:,1) >= startlabel,1,'first');
            endpoint = find(tmpemg(:,1) <= endlabel,1,'last');
            index = [startpoint : endpoint];

            data.section{i + 1}.emg = tmpemg(index,:);
            tmpemg(index,:) = [];

            startpoint = tmpacc(1,1);
            endpoint = tmpacc(size(tmpacc,1),1);
            startpoint = find(tmpacc(:,1) >= startlabel,1,'first');
            endpoint = find(tmpacc(:,1) <= endlabel,1,'last');
            index = [startpoint : endpoint];

            data.section{i + 1}.acc = tmpacc(index,:);
            tmpacc(index,:) = [];
        end
    end       
else
    error('Error: wrong filename');
end

%% the end of the function
end
            