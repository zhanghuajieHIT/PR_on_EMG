function AAC=feature_AAC(y)
% AAC:average amplitude change
% y:256*8

[R, C] = size(y);
AAC = zeros(1, C);
for i =1:C
    len = 0;
    for j = 1: R-1
        len  = len + abs(y(j+1,i) - y(j,i));
    end
    AAC(1,i) = (1/R)*len;   
end

end