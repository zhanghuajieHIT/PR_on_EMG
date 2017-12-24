function [bestacc,bestc,bestg] = girdsearch_SVM(data,label)
% 网格搜索最佳的c和g参数

cmin=-8;
cmax=8;
gmin=-8;
gmax=8;
cstep=0.8;
gstep=0.8;
[C, G] = meshgrid(cmin:cstep:cmax, gmin:gstep:gmax); 
[m,n] = size(C); 
acc = zeros(m,n); 
eps = 10^(-2); 
basenum = 2; % 以2为底数
bestacc = 0; 
bestc = 1; 
bestg = 0.1; 
opts_t=2;%核函数的类型，为4时是自定义核函数
kernelType='rbf';%自定义的核函数的类型
kflod=10;
for i = 1:m 
    for j = 1:n  
        tmp_gamma = basenum^G(i,j); 
        tmp_C = basenum^C(i,j); 
        cmd = ['-c ',num2str(tmp_C), ' -g ',num2str(tmp_gamma),...
            ' -t ', num2str(opts_t),' -v ',num2str(kflod)];         
        if opts_t ~= 4 
            acc(i,j)=libsvmtrain(label,data,cmd);
        else 
            kernelPara=basenum^G(i,j);
            kernel = kernelFunc(data,kernelType,kernelPara); % 自定义核函数
            Ktrain=[(1:size(data,1))',kernel];
            cmd=['-c ',num2str(tmp_C),' -t ', num2str(opts_t),' -v ',num2str(kflod)];
            acc(i,j)=libsvmtrain(label,Ktrain,cmd);
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

end

