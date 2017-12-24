function [output] = Filter_data(data,subfilter)
%% filter for deal with the 50Hz
output = zeros(size(data));
for i = 1 : subfilter.len
    %% start the filter
    output(i) = subfilter.fb(length(subfilter.fb) + 1 - i: end) * data(1 : i) ...
        - subfilter.fa(length(subfilter.fb) + 1 - i: end) * output(1 : i - 1);
    
end

for i = subfilter.len + 1 : length(data)
    output(i) = subfilter.fb * data(i - subfilter.len : i) ...
        - subfilter.fa * output(i - subfilter.len : i - 1);
end


end