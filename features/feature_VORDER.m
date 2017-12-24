function VORDER=feature_VORDER(y)
% VORDER:v-Order
% y:256*8
% v:the order,best order is 2

v=3;
[R,C]=size(y);
VORDER=((1/R)*sum(y.^v,1)).^(1/v);

end
