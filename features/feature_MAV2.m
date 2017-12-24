function MAV2 = feature_MAV2( y )
% MAV2:modified mean absolute value type 2
% MAV1 with a continuous weighting window
% y:256*8

[R, C] = size(y);
MAV2 = zeros(1,C);

for i = 1:C
    temp = 0;
    for j =1:R
        if((j >= .25*R) && (j <= .75*R))
            w = 1;
        elseif(j < .25*R)
            w = (4*j)/R;
        else
            w = 4*(j-R)/R;
        end
        temp = temp +(w*abs(y(j,i)));
    end
    MAV2(1,i) = (1/R)*temp;
end

end
