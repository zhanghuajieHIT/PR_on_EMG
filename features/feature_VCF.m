function VCF=feature_VCF(y)
% y:256*8
% VCF:variance of central frequency

[R,C]=size(y);
VCF=zeros(1,C);
for i = 1:C
    [Pxx, W] = pwelch(y(:,i));
    VCF(1,i) = (sum(Pxx.*(W.^2)))/(sum(Pxx.*(W.^0)))-((sum(Pxx.*(W.^1)))/(sum(Pxx.*(W.^0)))).^2;
end





end