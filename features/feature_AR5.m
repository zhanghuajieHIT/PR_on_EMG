function AR=feature_AR5(y)
% AR:autoregressive coefficients
% y:256*8
% level:the order of the model

level=5;
[R,C]=size(y);
AR=zeros(1,level*C);%5½×ARÄ£ÐÍ
for i=1:C
    feat = arburg( y(:,i),level);
    AR(1,1+(i-1)*level:level*i)=feat(2:(level+1));
end

end
