%
% GETIAVFEAT Gets the IAV feature (Integrated Absolute Value).
%
% feat = getiavfeat(x)
%
% Author Ding Qichuan
%
% This function computes the IAV feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%
% Outputs
%    feat:     IAV value
% 24/07/12 DQC First created.

function feat = getiavfeat(x)

feat = sum(abs(x));