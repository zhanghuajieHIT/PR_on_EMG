function [sol,val]=fitness_SVMcg(sol,options)
% 优化SVM的c、g参数的适应度函数
% 用识别正确率作为适应度，可以考虑用别的参数作为适应度

global trainData trainLabel
featData=trainData;
featLabel=trainLabel;
c=sol(1);
g=sol(2);
%% 分类正确率作为适应度
% 使用交叉验证的方法
K=10;
cmd=['-c ',num2str(c),' -g ',num2str(g),' -v ',num2str(K)];
result=libsvmtrain(featLabel,featData,cmd);
val=result;




end