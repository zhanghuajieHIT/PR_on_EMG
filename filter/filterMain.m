function rawEMG=filterMain(data,F_low,F_high,channelNum)
% for the filter of the signal
% data:datalength*channelnum
% (F_low,F_high)���˲���Χ

filter=Filter_Build(F_low,F_high);%�˲���
rawEMG=zeros(length(data),channelNum);%��ʼ��һ���յĽṹ���飬������ѭ���л���´ε�������Ӱ��
for i=1:channelNum
    data_bandpass=Filter_data(data(:,i),filter.bandpass);%��ͨ�˲�����
    rawEMG(:,i)=Filter_data(data_bandpass,filter.bandstop);%�ݲ��˲�����
end

end

