%
%
% feat = getlogdetectfeat(x)
%
% Author Ding Qichuan
%
% This function computes the log_detector feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%
% Outputs
%    feat:     logdetector value
% 24/07/12 DQC First created.

function feat = getlogdetectfeat(x)

feat = exp(mean(log(abs(x))));