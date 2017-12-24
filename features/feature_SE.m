function SampEn=feature_SE( y )
% SampEn: Sample Entropy
% y:256*8
%   calculates the sample entropy of a given time series data

%   SampEn is conceptually similar to approximate entropy (ApEn), but has
%   following differences:
%       1) SampEn does not count self-matching. The possible trouble of
%       having log(0) is avoided by taking logarithm at the latest step.
%       2) SampEn does not depend on the datasize as much as ApEn does. The
%       comparison is shown in the graph that is uploaded.

%   dim     : embedded dimension
%   r       : tolerance (typically 0.2 * std)
%   y    : time-series data
%
%---------------------------------------------------------------------
% original:
% coded by Kijoon Lee,  kjlee@ntu.edu.sg
% Mar 21, 2012
%---------------------------------------------------------------------

dim=1;%dim和r参数都需要试着调整
[R,C]=size(y);
SampEn=zeros(1,C);
for j=1:C
    r=0.2*std(y(:,j));
    correl = zeros(1,2);
    dataMat = zeros(dim+1,R-dim);
    for i = 1:dim+1
        dataMat(i,:) = y(i:R-dim+i-1,j);
    end
    for m = dim:dim+1
        count = zeros(1,R-dim);
        tempMat = dataMat(1:m,:);
        for i = 1:R-m
        % calculate Chebyshev distance, excluding self-matching case
        % dist = max(abs(tempMat(:,i+1:N-dim) - repmat(tempMat(:,i),1,N-dim-i)));
        
            if m==1;
                dist = abs(bsxfun(@minus,tempMat(:,i+1:R- dim),tempMat(:,i)));
            else
                dist = max(abs(bsxfun(@minus,tempMat(:,i+1:R-dim),tempMat(:,i))));
            end
        % calculate Heaviside function of the distance
        % User can change it to any other function
        % for modified sample entropy (mSampEn) calculation
            D = (dist < r);       
            count(i) = sum(D)/(R-dim);
        end
        correl(m-dim+1) = sum(count)/(R-dim);
    end
    SampEn(1,j) = log(correl(1)/correl(2));
end

end


