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
%   �ݹ����
% 24/07/12 DQC First created.

function feat = getar_rcfeat(x,order)          %����feat�в���������˳���ǣ�[a1; a2; a3; a4]

datasize = size(x,1);
feat = zeros(order,1);
P = eye(order);

for i = 1:(datasize-order)
    
    X = x(i:(i+order-1),:);
    feat = feat + P*X*(x(i+order,1) - X'*feat);         %ÿ��Ԥ��Ľ�����и��� 
    P = P - P*(X*X')*P/(1+X'*P*X);
end

feat = flipud(feat);

   