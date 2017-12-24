%
% GETIAVFEAT Gets the wamp feature (Willison Amplitude).
%
% feat = getwampfeat(x)
%
% Author Ding Qichuan
%
% This function computes the wamp feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%    threshold:  the threshold of the amplitude
%
% Outputs
%    feat:     wamp value
% 24/07/12 DQC First created.

function feat = getwampfeat(x, threshold)

datasize = size(x,1);

feat = 0;

for i = 2:datasize
    if abs(x(i,1) - x(i-1,1)) > threshold
        feat = feat + 1;
    end
end
feat = feat/datasize;