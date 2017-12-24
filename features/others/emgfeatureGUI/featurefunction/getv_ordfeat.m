%
% GETIAVFEAT Gets the v_order feature (v=2).
%
% feat = getv_ordfeat(x)
%
% Author Ding Qichuan
%
% This function computes the v_order feature of the signals in x,
%
% Inputs
%    x: 		a column of signals
%    v:         the order
%
% Outputs
%    feat:     v_order value
%
%   there is study indicating that the best value for v is 2, which lead to
%   the definition of the EMG v-order feature as the same as the square
%   root of the var feature.
% 24/07/12 DQC First created.

function feat = getv_ordfeat(x, v)

feat = nthroot(mean(abs(x).^v),v);
