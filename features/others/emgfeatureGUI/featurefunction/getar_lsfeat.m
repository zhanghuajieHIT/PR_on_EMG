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
% ��С�������
% 24/07/12 DQC First created.

function feat = getar_lsfeat(x,order)                   %����feat�в���������˳���ǣ�[a4; a3; a2; a1]

datasize = size(x,1);
X = zeros((datasize-order),order);

for i = 1:(datasize-order)
    X(i,:) = x(i:(i+order-1),1)';
end

Y = x((order+1):datasize,1);

feat = (X'*X)\(X'*Y);




   