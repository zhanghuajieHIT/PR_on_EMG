%
% GETRMSFEAT Gets the RMS feature (Root Mean Square).
%
% feat = getrmsfeat(x)
%
% Author Ding Qichuan
%
% This function computes the RMS feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%
% Outputs
%    feat:     RMS value
% 24/07/12 DQC First created.

function feat = getrmsfeat(x)

feat = sqrt(mean(x.^2));