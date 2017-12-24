function RMS=feature_RMS(y)
% RMS:root mean square
% y:256*8
[R,C]=size(y);
RMS=zeros(1,C);
for i=1:C
    RMS(1,i)=sqrt((1/R)*sum(y(:,i).^2));
end

% %% another code
% RMS=rms(y);