function AFB=feature_AFB(y)
% AFB:amplitude of the first bust
% y:256*8
% len:the langth of hamming window
% 没有参考公式，看别人的代码改写的，感觉不是很靠谱

[R,C]=size(y);
h=hamming(R);
AFB=zeros(1,C);
for i=1:C
    flag=0;
    signalAfterFilter=y(:,i).*h;%signalAfterFilter的长度也是R，即数据长度
    for j=2:R-1
        if((signalAfterFilter(j)>signalAfterFilter(j-1))&&(signalAfterFilter(j)>signalAfterFilter(j+1)))
            AFB(1,i)=signalAfterFilter(j);
            flag=1;
            break;
        end       
    end
    if flag==0
        if signalAfterFilter(1)>signalAfterFilter(R)%加入没有找到符合要求的点
            AFB(1,i)=signalAfterFilter(1);
        else
            AFB(1,i)=signalAfterFilter(R);
        end
     end
end

end

