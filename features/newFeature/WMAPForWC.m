function feat=WMAPForWC(y)
% y�ĸ��е�������һ�����
% y��һ��cell,1*?cell

[~,rowNum]=size(y);
feat=zeros(1,rowNum);
thresh=0.000015;
for i=1:rowNum
    temp=abs(diff(y{i})); 
    R=length(temp); 
    count=0;
    for j=1:R
        if temp(j)>=thresh
            count=count+1;
        end
    end
    feat(1,i)=count;
end
       
end

