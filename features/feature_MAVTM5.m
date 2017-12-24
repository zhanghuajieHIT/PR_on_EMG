function MAVTM=feature_MAVTM5(y)
% MAVTM:absolute value of the order temporal moment
% 有些文献也叫TMorder
% y:256*8
% order:阶数，一般为3,4,5.

order=5;
[R,C]=size(y);
MAVTM=zeros(1,C);
for i=1:C
    MAVTM(1,i)=abs((1/R)*sum(y(:,i).^order,1));
end

end