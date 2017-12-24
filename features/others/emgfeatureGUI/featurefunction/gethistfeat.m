%
%
% feat = gethistfeat(x)
% 
% Author Ding Qichuan
%
% This function computes the hist feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%   emg_range: the minimum and the a maximum emg voltage value are
%   -/+emg_range  要根据每个通道的情况分别确定
%   deadzone: the range near the baseline  emg_rang>deadzone
% Outputs
%    feat:     the histogram or frequency with which the emg voltage falls
%  the number of bins is set to nine  暂定分成9个
%    within each of the voltage bins
% 24/07/12 DQC First created.

function feat = gethistfeat(x, emg_range, deadzone)


feat = zeros(9,1);

datasize = size(x,1);

h = (emg_range - deadzone)/4;

for i = 1:datasize
    if  x(i,1) >= -deadzone && x(i,1) <= deadzone
        feat(5,1)  = feat(5,1) + 1;
    elseif x(i,1) > deadzone && x(i,1) <= (deadzone + h)
        feat(4,1) = feat(4,1) + 1;
    elseif x(i,1) > (deadzone + h) && x(i,1) <= (deadzone + 2*h)
        feat(3,1) = feat(3,1) + 1;
    elseif x(i,1) > (deadzone + 2*h) && x(i,1) <= (deadzone + 3*h)
        feat(2,1) = feat(2,1) + 1;
    elseif x(i,1) > (deadzone + 3*h) && x(i,1) <= (deadzone + 4*h)
        feat(1,1) = feat(1,1) + 1;
        
    elseif x(i,1) < -deadzone  && x(i,1) >= (-deadzone - h)
        feat(6,1) = feat(6,1) + 1;
    elseif x(i,1) <  (-deadzone - h)  && x(i,1) >= (-deadzone - 2*h)
        feat(7,1) = feat(7,1) + 1;
    elseif x(i,1) < (-deadzone - 2*h)  && x(i,1) >= (-deadzone - 3*h)
        feat(8,1) = feat(8,1) + 1;
    elseif x(i,1) < (-deadzone - 3*h)  && x(i,1) >= (-deadzone - 4*h)
        feat(9,1) = feat(9,1) + 1;
    end
end
        