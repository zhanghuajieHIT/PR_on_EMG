%
% GETMAVFEAT Gets the MAV feature (Mean Absolute Value).
%
% feat = getmavfeat(x)
%
% Author Ding Qichuan
%
% This function computes the MAV feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%
% Outputs
%    feat:     MAV value 
% 24/07/12 DQC First created.

function feat = getmavfeat(x)

feat = mean(abs(x));

