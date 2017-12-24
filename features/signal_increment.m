function [ out ] = signal_increment( signal )
% Bins EMG signal incrementally creating overlapped segments of 100ms
% 用此函数可以不用以前方法的将原始数据分段为三维数组，但是原方法好些
% 具体使用时还需要修改参数
% 此方法的signal是单通道信号

t = .0005; % Sample frequency 2000 Hz = 1 sample/.5ms
inc = 50; % Shift after each bin,重叠时间为100ms，重叠长度为50
frame_length = .1; % Frame length in ms
n = frame_length/t;%200
frames = length(signal)/inc - n/inc+1;%等于信号长度能够分出的分段数量
out = zeros(n,frames);%输出为分段长度*分段数量
for k = 1:frames
    out(:,k) = signal((1+(k-1)*inc):((k-1)*inc+n));
end

end

