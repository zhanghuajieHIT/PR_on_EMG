function WL = feature_WL( y )
% WL:waveform length
% Returns the waveform length for the signal in each channel
% y:256*8

[R, C] = size(y);
WL = zeros(1, C);
for i =1:C
    len = 0;
    for j = 1: R-1
        len  = len + abs(y(j+1,i) - y(j,i));
    end
    WL(1,i) = len;
end


end