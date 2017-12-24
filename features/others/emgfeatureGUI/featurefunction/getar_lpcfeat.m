%
% GETARFEAT Gets the AR feature (autoregressive).
%
% feat = getarfeat(x,order)
%
% Author Ding Qichuan
%
% This function computes the AR feature of the signals in x,
%
% AR model determined using the Levinson-Durbin algorithm.
%
% Inputs
%    x: 		columns of signals
%    order:     order of AR model
%
% Outputs
%    feat:     AR value
%                   (AR coefficients from the next signal is to the right of the previous signal)
%  ��С������⣬ֱ��ʹ�ú���lpc
% 24/07/12 DQC First created.

function feat = getar_lpcfeat(x,order)                %����feat�в���������˳���ǣ�[a1; a2; a3; a4]

cur_xlpc = real(lpc(x,order)');
feat = -cur_xlpc(2:(order+1),:);
   