function DASDV=feature_DASDV(y)
% DASDV:difference absolute standard deviation
% y:256*8

[R, C] = size(y);
DASDV = zeros(1, C);
for i =1:C
    len = 0;
    for j = 1: R-1
        len  = len + (y(j+1,i) - y(j,i)).^2;
    end
    DASDV(1,i) = sqrt((1/(R-1))*len);
end

end