function SSI = feature_SSI( y )
% SSI:simple square integral
% Returns the sum of the squares of k elements in bin i of the
% signal
% y:256*8

[R,C] = size(y);
SSI = zeros(1,C);

for i = 1:C
    SSI(1,i) = sum((y(:,i).^2));
end

end