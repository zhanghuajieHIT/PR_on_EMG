function WTE=feature_WTE(y)
% WCE:the energy of the wavelet coefficients
% 小波系数能量其实就是其平方值
% 分解后子频段信号的平均能量：E=sum((Si).^2)/N，其中N表示Si的长度，Si表示分解后的子频段
% 也可以尝试不用平均能量，用总能量
% y:256*8
% name:the name of wavalet,such as haar,db,用单引号括起
% level:the level of the wavelet

name='db2';
level=5;
[R,C]=size(y);
WTE=zeros(1,C*(level+1));
for i=1:C
    [c,l]=wavedec(y(:,i),level,name);
    %5级小波分解，db5小波，分解级数和小波基可后期更改成合适的
    [Ea,Ed] = wenergy(c,l);
    WTE(1,1+(i-1)*(level+1):(level+1)*i)=[Ea,Ed]/100*(sum(y(:,i).^2));
%     WCE(1,1+(i-1)*(level+1):(level+1)*i)=[Ea,Ed];%较弱
end

%% 还需要对能量进行归一化
% for i=1:C
%     [c,l]=wavedec(y(:,i),level,name);
%     %5级小波分解，db5小波，分解级数和小波基可后期更改成合适的
%     a5=appcoef(c,l,name,level);%提取低频系数，尺度为5
%     d5=detcoef(c,l,5); %提取高频系数
%     d4=detcoef(c,l,4); 
%     d3=detcoef(c,l,3); 
%     d2=detcoef(c,l,2); 
%     d1=detcoef(c,l,1); 
%     e6=sum(a5.^2)/length(a5);
%     e5=sum(d5.^2)/length(d5);
%     e4=sum(d4.^2)/length(d4);
%     e3=sum(d3.^2)/length(d3);
%     e2=sum(d2.^2)/length(d2);
%     e1=sum(d1.^2)/length(d1);
%     WCE(1,1+(i-1)*(level+1):(level+1)*i)=[e6,e5,e4,e3,e2,e1]; 
% end

end

