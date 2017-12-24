function MAV = feature_MAV( y )
% Calculates the mean of the absolute values for k signals in i bins
% MAV:mean absolute value
% MAV also call IAV
% y:emg signal,256*8

[R,C] = size(y);
MAV = zeros(1,C);
for i = 1:C
%     MAV(1,i) = (1/R)*sum(abs(y(:,i)));
    MAV(1,i) = mean(abs(y(:,i)));
end
% MAV=MAV./(sum(MAV.^2))^0.5;
end

