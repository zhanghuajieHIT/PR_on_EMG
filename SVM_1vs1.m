function plabel = SVM_1vs1(x,model)
% 仅有两类数据分类
% x为测试数据
% model为已经训练好的模型

gamma = model.Parameters(4);
RBF = @(u,v)( exp(-gamma.*sum( (u-v).^2) ) );%定义rbf函数
 
len = length(model.sv_coef);
y = 0;

for i = 1:len
u = model.SVs(i,:);
y = y + model.sv_coef(i)*RBF(u,x);
end
b = -model.rho;
y = y + b;
 
if y >= 0
plabel = 1;
else
plabel = -1;
end

