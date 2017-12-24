function HIST=feature_HIST(y)
% HIST:histogram of EMG
% ����ÿ��ͨ���ź������ֱ��ͼ�������ݶ�Ϊ9��
% y:256*8
% emg_range: the minimum and the maximum emg voltage value are
% -/+emg_range  Ҫ����ÿ��ͨ��������ֱ�ȷ��
% deadzone: the range near the baseline  emg_rang>deadzone
% ע�⣬emg_range��deadzone����Ҫ����ͨ���ľ����������
% �˷����õ�������ά�Ȼ�����

emg_range=0.0003;%���Ը��ݲ�ͬ��ͨ���趨��ͬ��ֵ
deadzone=0.00003;
HIST= zeros(1,9*8);
tempHIST = zeros(1,9);
[R,C] = size(y);
h = (emg_range - deadzone)/4;
for j=1:C
    for i = 1:R
        if  y(i,j) >= -deadzone && y(i,j) <= deadzone
            tempHIST(1,5)  = tempHIST(1,5) + 1;
        elseif y(i,j) > deadzone && y(i,j) <= (deadzone + h)
            tempHIST(1,4) = tempHIST(1,4) + 1;
        elseif y(i,j) > (deadzone + h) && y(i,j) <= (deadzone + 2*h)
            tempHIST(1,3) = tempHIST(1,3) + 1;
        elseif y(i,j) > (deadzone + 2*h) && y(i,j) <= (deadzone + 3*h)
            tempHIST(1,2) = tempHIST(1,2) + 1;
        elseif y(i,j) > (deadzone + 3*h) && y(i,j) <= (deadzone + 4*h)
            tempHIST(1,1) = tempHIST(1,1) + 1;
        
        elseif y(i,j) < -deadzone  && y(i,j) >= (-deadzone - h)
            tempHIST(1,6) = tempHIST(1,6) + 1;
        elseif y(i,j) <  (-deadzone - h)  && y(i,j) >= (-deadzone - 2*h)
            tempHIST(1,7) = tempHIST(1,7) + 1;
        elseif y(i,j) < (-deadzone - 2*h)  && y(i,j) >= (-deadzone - 3*h)
            tempHIST(1,8) = tempHIST(1,8) + 1;
        elseif y(i,j) < (-deadzone - 3*h)  && y(i,j) >= (-deadzone - 4*h)
            tempHIST(1,9) = tempHIST(1,9) + 1;
        end
    end
    HIST(1,(1+9*(C-1)):9*C)=tempHIST;
end
        
end

