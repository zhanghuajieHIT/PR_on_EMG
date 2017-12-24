function Range=feature_Range(y)
% Range=|max-min|
% y:256*8

Range=abs(max(y)-min(y));
end
