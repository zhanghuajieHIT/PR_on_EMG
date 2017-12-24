%%the filter part, need to load the function in the file of 1207
spare_fl = Filter_Build();
for i = 1 : 24
    for j = 2 : 10
        raw{i}.section{j}.filter_emg(:,1) = data_full{i}.section{j}.emg(:,1);
        for k = 1 : 8
            raw{i}.section{j}.filter_emg(:,k + 1) = Filter_data(data_full{i}.section{j}.emg(:,k + 1),spare_fl.bandpass);
        end
    end
end
