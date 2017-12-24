%
% GETWLFEAT Gets the waveform length feature.
%
% feat = getwlfeat(x)
%
% Author Ding Qichuan
%
% This function computes the waveform length feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%
% Outputs
%    feat:     waveform length value 
% 24/07/12 DQC First created.

function feat = getwlfeat(x)

datasize = size(x,1);
feat = sum(abs(diff(x)))/datasize;
