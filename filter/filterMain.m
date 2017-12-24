function rawEMG=filterMain(data,F_low,F_high,channelNum)
% for the filter of the signal
% data:datalength*channelnum
% (F_low,F_high)是滤波范围

filter=Filter_Build(F_low,F_high);%滤波器
rawEMG=zeros(length(data),channelNum);%初始化一个空的结构数组，否则在循环中会对下次的数据有影响
for i=1:channelNum
    data_bandpass=Filter_data(data(:,i),filter.bandpass);%带通滤波处理
    rawEMG(:,i)=Filter_data(data_bandpass,filter.bandstop);%陷波滤波处理
end

end

