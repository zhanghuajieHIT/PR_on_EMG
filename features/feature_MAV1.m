function MAV1 = feature_MAV1( y )
% MAV1:modified mean absolute value type 1
% Calculates the weighted mean of the absolute values for k signals in i bins
% weight equals 1 if index of value in bin is in the middle of the bin
% (between .25 and .75 of the bin size) and .5 otherwise
% y:256*8
[R, C] = size(y);
MAV1 = zeros(1,C);

for i = 1:C
    temp = 0;
    for j =1:R
        if((j >= .25*R) && (j <= .75*R))
            w = 1;
        else
            w = .5;
        end
        temp = temp +(w*abs(y(j,i)));
    end
    MAV1(1,i) = (1/R)*temp;
end

end

