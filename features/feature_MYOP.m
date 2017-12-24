function MYOP= feature_MYOP(y,thresh)
% MYOP:myopulse percentage rate
% thresh:threshold
% y:256*8


[R,C]=size(y);
MYOP=zeros(1,C);

if nargin==2
    if length(thresh)==1
        thresh=ones(C,1)*thresh;
    end
end
if nargin<2
    thresh=ones(C,1)*0.00003;
end

for i=1:C
    count=0;
    for j=1:R
        if (y(j,i)>=thresh(i))
            count=count+1;
        end
    end
    MYOP(1,i)=(1/R)*count;              
end

end