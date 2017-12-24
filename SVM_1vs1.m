function plabel = SVM_1vs1(x,model)
% �����������ݷ���
% xΪ��������
% modelΪ�Ѿ�ѵ���õ�ģ��

gamma = model.Parameters(4);
RBF = @(u,v)( exp(-gamma.*sum( (u-v).^2) ) );%����rbf����
 
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

