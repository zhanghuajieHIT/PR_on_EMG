function WAMP2=feature_WAMP2(y)
% y:256*8


thresh=0.000015^2;
[R, C] = size(y);
WAMP2 = zeros(1, C);
absdiff = abs(diff(y.^2));%此处区别于WAMP


for i =1:C
    count = 0;
    for j = 1: R-2
        if(absdiff(j,i) >= thresh)
        count = count + 1;
        end
    end
    WAMP2(1,i) = count;
end


end