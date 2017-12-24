function SMN=feature_SM1(y)
% y:256*8
% SMN:the 1st,2nd,3rd spectral moments,N is the order,generally is 1,2,3

order=1;
[R,C]=size(y);
SMN = zeros(1,C);
for i = 1:C
    [Pxx, W] = pwelch(y(:,i));
    SMN(1,i) = sum(Pxx.*(W.^order));
end




end