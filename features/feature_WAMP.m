function WAMP = feature_WAMP( y ,thresh)
% WAMP:Willison amplitude
% Calculates the Willison amplitude (WAMP) of a bin
% WAMP equals the number of times the absolute difference between 
% two consecutive EMG samples exceeds a predetermined threshold
% y:256*8

% thresh=0.000015;%原来保存的特征都是0.00002

[R, C] = size(y);
WAMP = zeros(1, C);
absdiff = abs(diff(y));

if nargin==2
    if length(thresh)==1
        thresh=ones(C,1)*thresh;
    end
end
if nargin<2
    thresh=[0.000009,0.000015,0.000015,0.000015,0.000015,0.000015,0.00001,0.000015];
end

for i =1:C
    count = 0;
    for j = 1: R-1
        if(absdiff(j,i) >= thresh(i))
        count = count + 1;
        end
    end
    WAMP(1,i) = count;
end


end

