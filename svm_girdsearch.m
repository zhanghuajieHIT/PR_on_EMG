function [bestacc,bestc,bestg] = svm_girdsearch(label, data, ... 
    cbound, gbound, cgstep, svm_cmd, v, opts_t, ker_func) 
% opts_t:核函数的类型
% cmin:cstep:cmax  :: cost  
% gmin:gstep:gmax  :: gamma 
% v                :: cross validation n, default 5 
% t                :: '-t' for svmtrain 
% ker_func         :: function handle, used only if opts_t==4 
%                     ker_func(tr_data, gamma) 
 
if nargin < 8 
    opts_t = 2; 
elseif opts_t == 4 && nargin < 9 
    error('none of @ker_func.\n'); 
end 
if nargin < 7 
    v = 5; 
end 
if nargin < 6 
    svm_cmd = ''; 
end 
if nargin < 5 
    cstep = 0.8; 
    gstep = 0.8;    
else 
    cstep = cgstep(1); 
    gstep = cgstep(2); 
end 
if nargin < 4 
    gmax = 8; 
    gmin = -8;    
else 
    gmax = gbound(2); 
    gmin = gbound(1); 
end 
if nargin < 3 
    cmax = 8; 
    cmin = -8; 
else 
    cmax = cbound(2); 
    cmin = cbound(1); 
end 
 
[C, G] = meshgrid(cmin:cstep:cmax, gmin:gstep:gmax); 
[m,n] = size(C); 
acc = zeros(m,n); 
 
eps = 10^(-2); 
basenum = 2; 
bestacc = 0; 
bestc = 1; 
bestg = 0.1; 
for i = 1:m 
    for j = 1:n  
        tmp_gamma = basenum^G(i,j); 
        tmp_C = basenum^C(i,j); 
         
        cmd = [svm_cmd, ' -c ',num2str(tmp_C), ' -g ',... 
            num2str(tmp_gamma), ' -t ', num2str(opts_t), ' -q '];         
        if opts_t ~= 4 
            acc(i,j) = cross_validation(label, data, cmd, v, 'svmtrain');  % 交叉验证函数（自己写的）
        else 
            ker = ker_func(data, basenum^G(i,j));      % 自定义核函数时，这里不用太关注 
            acc(i,j) = cross_validation(label, ker, cmd, v, 'svmtrain');             
        end 
         
        if acc(i,j) > bestacc 
            bestacc = acc(i,j); 
            bestg = tmp_gamma; 
            bestc = tmp_C; 
        end 
         
        % 当精度差别不大时，选择C值小的一组参数值 
        if abs(bestacc - acc(i,j)) < eps && tmp_C < bestc 
            bestacc = acc(i,j); 
            bestg = tmp_gamma; 
            bestc = tmp_C;             
        end 
         
        fprintf('cross validation (g=%s,C=%s) finished %d%%.\n', ... 
            num2str(tmp_gamma), num2str(tmp_C), floor(100*(i*n+j)/(m*n)) ); 
    end 
end 
 
% plot relationship bwtween g/c and acc 
figure; 
meshc(C,G,acc); 
axis([cmin,cmax,gmin,gmax,30,100]); 
xlabel('log2c','FontSize',10); 
ylabel('log2g','FontSize',10); 
zlabel('Accuracy(%)','FontSize',10); 
firstline = '[GridSearchMethod]';  
secondline = ['Best c=',num2str(bestc),' g=',num2str(bestg), ... 
    ' CVAccuracy=',num2str(bestacc),'%']; 
title({firstline;secondline},'Fontsize',10); 
 
end 