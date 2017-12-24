function SSC = feature_SSC( y ,thresh)
%SSC:slope sign change
% Number of slope sign changes of a signal
% Returns the number of times the slope of the signal's
% sign changes and the absolute value of one of the slopes
% is greater than or equal to the threshold 'thresh'
% y:emg signal:256*8
% thresh:threshold

[R, C] = size(y);
SSC = zeros(1, C);
slopes = diff(y);%256*8

if nargin==2
    if length(thresh)==1
        thresh=ones(C,1)*thresh;
    end
end
if nargin<2
    thresh=ones(C,1)*0.00003;
end

for i =1:C
    count = 0;
    for j = 1: R-2
        if((((slopes(j,i) > 0) && (slopes(j+1,i) < 0))...
                || ((slopes(j,i) < 0) && (slopes(j+1,i) > 0)))...
                && ((abs(slopes(j,i)) >= thresh(i))...
                || (abs(slopes(j+1,i)) >= thresh(i))))
        count = count + 1;
        end
    end
    SSC(1,i) = count;
end


end

