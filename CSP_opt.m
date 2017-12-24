function [WF]=CSP_opt(C1,C2)
% CSP operation 
% C1,C2表示两类
% C1,C2:样本数*特征维度

segmentLen=19;
trialNum=floor(size(C1,1)/segmentLen);
dim=size(C1,2);
R1=zeros(dim);
R2=zeros(dim);
for i=1:trialNum
    T1=C1(segmentLen*(i-1)+1:segmentLen*i,:);
    T2=C2(segmentLen*(i-1)+1:segmentLen*i,:);
    T1=T1-ones(segmentLen,1)*mean(T1);
    T2=T2-ones(segmentLen,1)*mean(T2);
    R1Temp=(T1'*T1)/trace(T1'*T1);%求协方差
    R2Temp=(T2'*T2)/trace(T2'*T2);
    R1=R1+R1Temp;
    R2=R2+R2Temp;
end
R1=R1/trialNum;%平均协方差
R2=R2/trialNum;
RSum=R1+R2;%混合空间协方差
[USum,DSum]=eig(RSum);%DSum是由特征值构成的对角阵，USum的列是特征值对应的特征向量
%对于对称矩阵eig求的特征值是自动排序的
DDiag=diag(DSum);%返回主对角线上的元素,即特征值

U=USum;
D=diag(DDiag.^-0.5);
P=U*D;%白化处理
Y1=P'*R1*P;%
[U1,D1]=eig(Y1);

% by zhj 20170105
[~,newSort]=sort(diag(D1));% 对对角线数据排序
num=4;
WF=[P*U1(:,newSort(1:num)),P*U1(:,newSort(end-(num-1):end))];

% [~,iMax]=max(diag(D1));
% [~,iMin]=min(diag(D1));
% Fl=P*U1(:,i_l);
% Fs=P*U1(:,i_s);
% WF=[P*U1(:,iMax),P*U1(:,iMin)];
end



% function [result] = f_CSP(varargin)
% % This code is for calulating the projection matrix for CSP 
% % Haider Raza, Intelligent System Research Center, University of Ulster, Northern Ireland, UK.
% %     Raza-H@email.ulster.ac.uk
% %     Date: 03-Oct-2014
% 
% % Input:
%               
% %        left:  left hand data
% %       right: right hand data
% % 
% % Output:
% %       left: Left hand data
% %       right: right hand data    
% 
%     if (nargin ~= 2)
%         disp('Must have 2 classes for CSP!')
%     end
%     
%     Rsum=0;
%     %finding the covariance of each class and composite covariance
%     for i = 1:nargin 
%         %mean here?
%         R{i} = ((varargin{i}*varargin{i}')/trace(varargin{i}*varargin{i}'));%instantiate me before the loop!
%         %Ramoser equation (2)
%         Rsum=Rsum+R{i};
%     end
%    
%     %   Find Eigenvalues and Eigenvectors of RC
%     %   Sort eigenvalues in descending order
%     [EVecsum,EValsum] = eig(Rsum);
%     [EValsum,ind] = sort(diag(EValsum),'descend');
%     EVecsum = EVecsum(:,ind);
%     
%     %   Find Whitening Transformation Matrix - Ramoser Equation (3)
%         W = sqrt(inv(diag(EValsum))) * EVecsum';
%     
%     
%     for k = 1:nargin
%         S{k} = W * R{k} * W'; %       Whiten Data Using Whiting Transform - Ramoser Equation (4)
%     end
%    
%     %generalized eigenvectors/values
%     [B,D] = eig(S{1},S{2});
%     % Simultanous diagonalization
% 			% Should be equivalent to [B,D]=eig(S{1});
%     
%     [D,ind]=sort(diag(D));B=B(:,ind);
%     
%     %Resulting Projection Matrix-these are the spatial filter coefficients
%     result = B'*W;
% end


