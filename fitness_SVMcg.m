function [sol,val]=fitness_SVMcg(sol,options)
% �Ż�SVM��c��g��������Ӧ�Ⱥ���
% ��ʶ����ȷ����Ϊ��Ӧ�ȣ����Կ����ñ�Ĳ�����Ϊ��Ӧ��

global trainData trainLabel
featData=trainData;
featLabel=trainLabel;
c=sol(1);
g=sol(2);
%% ������ȷ����Ϊ��Ӧ��
% ʹ�ý�����֤�ķ���
K=10;
cmd=['-c ',num2str(c),' -g ',num2str(g),' -v ',num2str(K)];
result=libsvmtrain(featLabel,featData,cmd);
val=result;




end