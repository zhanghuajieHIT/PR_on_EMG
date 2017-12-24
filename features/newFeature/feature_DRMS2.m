function DRMS2=feature_DRMS2(y,feat)
% DRMS2:diff RMS
% y:256*8
% feat:��һ�δ�����ȡ��������
% DRMS2ָ���Ƕ��ź�RMS����󣬽���diff(feat(1:8),DRMS2(1:8))������16��

[R,C]=size(y);
DRMS2=zeros(1,2*C);
DRMS2(1,1:C)=rms(y);
DRMS2(1,C+1:end)=abs(diff([feat(1,1:8);rms(y)]));


end



