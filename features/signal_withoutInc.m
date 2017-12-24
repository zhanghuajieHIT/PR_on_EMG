function [ out ] = signal_withoutInc( signal )
% Breaks up EMG signal into 100 ms bins, creating disjoint segments
% 此方法的signal是单通道信号
% 得到的分段没有重叠
% 具体参数需要重新设置

t = .0005; %sampling time constant .5 ms,Sample frequency 2000 Hz = 1 sample/.5ms
frame_length = .1; %desired frame length 100 ms
n = frame_length/t; %num samples per frame,200
frames = length(signal)/n; %number of frames is the num of samples in signal/n samples per frame
out=zeros(n,frames); %preallocate the matrix for 20 colums of Nsamples/20 in each
for k=1:frames
    out(:,k)=signal(1+n*(k-1):n*k);
end

end
