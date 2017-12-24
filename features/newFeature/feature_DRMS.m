function DRMS=feature_DRMS(y)
% DRMS:diff RMS
% y:256*8
% DRMSָ���Ƕ��ź�RMS������ٶ�8ͨ����diff�����Ϊ15������

[R,C]=size(y);
DRMS=zeros(1,2*C-1);
DRMS(1,1:C)=rms(y);
DRMS(1,C+1:end)=abs(diff(DRMS(1,1:C)));
end
