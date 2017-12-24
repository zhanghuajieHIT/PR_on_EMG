%
% GETZCFEAT Gets the ZC feature (zero crossing).
%
% feat = getsscfeat(x,deadzone)
%
% Author Ding Qichuan
%
% This function computes the ZC feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%    deadzone:  +/- zone signal must cross to be considered a deadzone
%
% Outputs
%    feat:     ZC value
% 24/07/12 DQC First created.

function feat = getzcfeat(x,deadzone)

datasize = size(x,1);
feat = 0;

for i = 2:datasize
    
    if abs(x(i,1) - x(i-1,1)) > deadzone && x(i,1)*x(i-1,1) < 0
        feat = feat + 1;
    end
    
end

feat = feat/datasize;