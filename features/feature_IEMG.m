function IEMG=feature_IEMG(y)
% IEMG:integrated EMG
% y:256*8

IEMG=sum(abs(y));%�������

end