% % this function generates CSP matrix WF (n*2)
% % for feature vector X (1*n), 
% % X*WF output the most easily recognized features
% function [Fl,Fs]=csp_eeg(C1,C2)
function WF=csp_eeg(C1,C2)
N_matrix=19;
N_trial=floor(size(C1,1)/N_matrix);
dim=size(C1,2);
R1=zeros(dim);
R2=zeros(dim);
for i=1:N_trial
    T1=C1(N_matrix*(i-1)+1:N_matrix*i,:);
    T2=C2(N_matrix*(i-1)+1:N_matrix*i,:);
    T1=T1-ones(N_matrix,1)*mean(T1);
    T2=T2-ones(N_matrix,1)*mean(T2);
    R1_temp=(T1'*T1)/trace(T1'*T1);%求协方差
    R2_temp=(T2'*T2)/trace(T2'*T2);
    R1=R1+R1_temp;
    R2=R2+R2_temp;
end
R1=R1/N_trial;%平均协方差
R2=R2/N_trial;
R_sum=R1+R2;%混合空间协方差
[U_sum,D_sum]=eig(R_sum);%D_sum是由特征值构成的对角阵，U_sum的列是特征值对应的特征向量
%对于对称矩阵eig求的特征值是自动排序的
D_diag=diag(D_sum);%返回主对角线上的元素,即特征值
% 需要先排序
p_index=0;
for i=1:15
    if D_diag(i)<1e-4
        p_index=i;
    end
end
p_index=p_index+1;
U_pca=U_sum(:,p_index:dim);
D_pca=diag(D_diag(p_index:dim).^-0.5);
P=U_pca*D_pca;%白化处理
Y1=P'*R1*P;%
[U1,D1]=eig(Y1);
[~,i_l]=max(diag(D1));
[~,i_s]=min(diag(D1));
% Fl=P*U1(:,i_l);
% Fs=P*U1(:,i_s);
WF=[P*U1(:,i_l),P*U1(:,i_s)];
end


    