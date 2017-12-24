function MVC=feature_MVC(y)
% MC:mean value crossing，过均值点个数
% y:256*8

[R, C] = size(y);
MVC = zeros(1, C);
temp=mean(y);
thresh=0.0003;

for i =1:C
    count = 0;
    for j = 1: R-1
        if((((y(j,i) > temp) & (y(j+1,i) < temp))...
                | ((y(j,i) < temp) & (y(j+1,i) > temp)))...
                & abs(y(j,i) - y(j+1,i)) >= thresh)
        count = count + 1;
        end
    end
    MVC(1,i) = count;
end





end