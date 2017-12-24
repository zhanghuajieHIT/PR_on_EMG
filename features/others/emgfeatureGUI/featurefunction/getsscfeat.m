%
% GETSSCFEAT Gets the slope sign change feature.
%
% feat = getsscfeat(x,deadzone)
%
% Author Ding Qichuan
%
% This function computes the slope sign chnage feature of the signals in x,
%
%
% Inputs
%    x: 		a column of signals
%    deadzone:  +/- zone slope must cross to be considered a deadzone
%                 Note: that slope assumes a unitless time scale
%
% Outputs
%    feat:   the number of slope sign changes
% 24/07/12 DQC First created.

function feat = getsscfeat(x,deadzone)

datasize = size(x,1);

feat = 0;

for j = 3:datasize
    
    if (x(j-1,1)-x(j-2,1))*(x(j-1,1)-x(j,1)) > deadzone
        feat = feat + 1;
    end
    
end

feat = feat/datasize;
