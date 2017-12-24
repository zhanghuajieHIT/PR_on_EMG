function newData=remSamp(oldData)
% remSamp:remove the abnormal samples
% oldData:the raw EMG data with abnormal samples
% oldData:256*8

meanValue1=mean(oldData);
distance1=abs(bsxfun(@minus,oldData,meanValue1));
meanValue2=mean(distance1);
distance2=abs(bsxfun(@minus,distance1,meanValue2));
[row,col]=find(bsxfun(@gt,distance2,5*meanValue2));
newData=oldData;
% 方法1
% for i=1:length(row)
%     newData(row(i),col(i))=meanValue2(col(i));
% end

%方法2
[R,~]=size(oldData);
newData(R*(col-1)+row)=meanValue2(col);

end

