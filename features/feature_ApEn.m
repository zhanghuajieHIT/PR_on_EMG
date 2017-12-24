function ApEn=feature_ApEn(y)
% ApEn:approximate entropy
% y:256*8,time-series data
% dim:embedded dimension
% r:tolerance (typically 0.2 * std)
% 测试结果很差

dim=3;
[R,C]=size(y);
ApEn=zeros(1,C);
for i=1:C
    r=0.2*std(y(:,i));
    signalmatrix=zeros(R-dim+1,dim);%构造信号矩阵
    for j=1:R-dim+1
        for k=1:dim
            signalmatrix(j,k)=y(j+k-1,i);
        end
    end
    temp=0;
    for ii=1:R-dim+1
        count=0;
        for jj=1:R-dim+1
            distance=zeros(dim,1);
            for kk=1:dim
                distance(kk,1)=abs(signalmatrix(jj,kk)-signalmatrix(jj,kk));
            end
            d=max(distance);%X(i)与X(j)的距离的最大值
            if d<r
                count=count+1;%如果距离小于阈值，则个数+1； 
            end
        end
        correl=(count-1)/(R-dim);
        if (correl>0)
            temp=temp+log(correl);
        end
    end
    ApEn(1,i)=temp/(R-dim+1);
end
end
