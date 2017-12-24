function WPTSVD=feature_WPTSVD(y)
% WPCSVD:the SVD of the wavelet packet coefficients
% y:256*8
% name:the name of wavalet packet,such as db,dmey 用单引号括起
% level:the level of wavelet packet decompose

level=3;
name='db2';
[R,C]=size(y);
WPTSVD=zeros(1,(2^level)*C);
for i=1:C
    T=wpdec(y(:,i),level,name);
    for j=0:2^level-1
        WPTSVD(1,1+(i-1)*C+j)=svd(wpcoef(T,[level j]));
    end
        
end

end

