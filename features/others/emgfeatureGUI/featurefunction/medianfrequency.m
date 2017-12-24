% MEDIANFREQUENCY This computes the median frequency of a power spectrum.
%
% mnf = medianfrequency(f,p)
%
% Author Adrian Chan
%
% This computes the median fequency of a power spectrum. The median
% frequency is such that the sum of all power densities below the median
% frequency is equal to the sum of all power densities above the median
% frequency. Here the median frequency is found by using a bisection
% search method. The median frequency estimate is skewed slightly to a 
% higher estimate because it corresponds to the frequency where the power
% below that frequency is equal to or exceeds half the total power, when
% increasing the frequency from its lowest value.
%
% Reference: Winter DA. Biomechanics and Motor Control of Human Movement.
% 3rd Ed. Hoboken, NJ: John Wiley and Sons Inc., 2005.
%
% Inputs
%    f: frequencies (Hz)
%    p: power spectral density values
%
% Outputs
%    mnf: median frequency 使用二叉树搜索计算中值频率
%
% Modifications
% 09/10/07 AC Changed search method to a bisection search for increased
%             speed
% 09/09/21 AC First created.
function mnf = medianfrequency(f,p)

N = length(f);
low = 1;
high = N;
mid = ceil((low+high)/2);

while ~( sum(p(1:mid)) >= sum(p((mid+1):N)) && sum(p(1:(mid-1))) < sum(p(mid:N)) )
    if sum(p(1:mid)) < sum(p((mid+1):N))
        low = mid;
    else
        high = mid;
    end

    mid = ceil((low+high)/2);
end

mnf = f(mid);
