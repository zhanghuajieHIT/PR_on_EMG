function WTE=feature_WTE(y)
% WCE:the energy of the wavelet coefficients
% С��ϵ��������ʵ������ƽ��ֵ
% �ֽ����Ƶ���źŵ�ƽ��������E=sum((Si).^2)/N������N��ʾSi�ĳ��ȣ�Si��ʾ�ֽ�����Ƶ��
% Ҳ���Գ��Բ���ƽ����������������
% y:256*8
% name:the name of wavalet,such as haar,db,�õ���������
% level:the level of the wavelet

name='db2';
level=5;
[R,C]=size(y);
WTE=zeros(1,C*(level+1));
for i=1:C
    [c,l]=wavedec(y(:,i),level,name);
    %5��С���ֽ⣬db5С�����ֽ⼶����С�����ɺ��ڸ��ĳɺ��ʵ�
    [Ea,Ed] = wenergy(c,l);
    WTE(1,1+(i-1)*(level+1):(level+1)*i)=[Ea,Ed]/100*(sum(y(:,i).^2));
%     WCE(1,1+(i-1)*(level+1):(level+1)*i)=[Ea,Ed];%����
end

%% ����Ҫ���������й�һ��
% for i=1:C
%     [c,l]=wavedec(y(:,i),level,name);
%     %5��С���ֽ⣬db5С�����ֽ⼶����С�����ɺ��ڸ��ĳɺ��ʵ�
%     a5=appcoef(c,l,name,level);%��ȡ��Ƶϵ�����߶�Ϊ5
%     d5=detcoef(c,l,5); %��ȡ��Ƶϵ��
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

