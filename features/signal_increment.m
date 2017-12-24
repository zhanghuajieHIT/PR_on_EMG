function [ out ] = signal_increment( signal )
% Bins EMG signal incrementally creating overlapped segments of 100ms
% �ô˺������Բ�����ǰ�����Ľ�ԭʼ���ݷֶ�Ϊ��ά���飬����ԭ������Щ
% ����ʹ��ʱ����Ҫ�޸Ĳ���
% �˷�����signal�ǵ�ͨ���ź�

t = .0005; % Sample frequency 2000 Hz = 1 sample/.5ms
inc = 50; % Shift after each bin,�ص�ʱ��Ϊ100ms���ص�����Ϊ50
frame_length = .1; % Frame length in ms
n = frame_length/t;%200
frames = length(signal)/inc - n/inc+1;%�����źų����ܹ��ֳ��ķֶ�����
out = zeros(n,frames);%���Ϊ�ֶγ���*�ֶ�����
for k = 1:frames
    out(:,k) = signal((1+(k-1)*inc):((k-1)*inc+n));
end

end

