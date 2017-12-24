function MAVS = feature_MAVS( y )
% MAVS:mean absolute value slope
% output length is input length - 1
% y:emg signal,256*8

mav=feature_MAV( y );
[R, C] = size(mav);

MAVS = zeros(1, C-1);
for i =1:C-1
    MAVS(1, i) = mav(i+1) - mav(i);
end

end

