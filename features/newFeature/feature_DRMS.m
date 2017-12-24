function DRMS=feature_DRMS(y)
% DRMS:diff RMS
% y:256*8
% DRMS指的是对信号RMS处理后，再对8通道求diff，输出为15列特征

[R,C]=size(y);
DRMS=zeros(1,2*C-1);
DRMS(1,1:C)=rms(y);
DRMS(1,C+1:end)=abs(diff(DRMS(1,1:C)));
end
