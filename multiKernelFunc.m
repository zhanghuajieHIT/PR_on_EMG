function [kernel,temp]=multiKernelFunc(trainData,testData,Temp,coef,kernelType)
%% �Զ���Ķ�˺���
% kernelType:�˺������ͣ�����������ϣ���˹�ˣ�rbf�����Ժˣ�lin������ʽ�ˣ�poly��
%                       sigmoid�ˣ�sig������['rbf','ploy']
% trainData:ѵ�����ݣ�����*ά��
% testData:��������,����*ά��
% kernelPara:�˺�������
% coef����Ӧ�˺�����ϵ��

kernelPara=zeros(length(kernelType),3);%��ʼ���˺����Ĳ���
for i=1:length(kernelType) %�Ժ˺����Ĳ������и�ֵ
    if strcmp('rbf',cell2mat(kernelType(i)))%�����rbf��
        kernelPara(i,1)=0.005;
    elseif strcmp('poly',cell2mat(kernelType(i)))%���Ժ�
        kernelPara(i,1:3)=[0.005 0 3];
    elseif strcmp('lin',cell2mat(kernelType(i)))||strcmp('gen',cell2mat(kernelType(i)))||strcmp('logk',cell2mat(kernelType(i)))...
            ||strcmp('power',cell2mat(kernelType(i)))
        kernelPara(i,:)=0;
    elseif strcmp('sig',cell2mat(kernelType(i)))
        kernelPara(i,1:2)=[0.01 0];
    elseif strcmp('rq',cell2mat(kernelType(i)))
        kernelPara(i,1)=50;
    elseif strcmp('cauchy',cell2mat(kernelType(i)))
        kernelPara(i,1)=3;
    elseif strcmp('expk',cell2mat(kernelType(i)))
        kernelPara(i,1)=12.5;
    elseif strcmp('inmk',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.45;
    elseif strcmp('multiq',cell2mat(kernelType(i)))%Ч������ޱ�
        kernelPara(i,1)=3;
    elseif strcmp('lap',cell2mat(kernelType(i)))
        kernelPara(i,1)=319;
    elseif strcmp('spher',cell2mat(kernelType(i)))
        kernelPara(i,1)=165;
    elseif strcmp('rbf2',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.004;
    elseif strcmp('rbf3',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.003;
    elseif strcmp('rbf4',cell2mat(kernelType(i)))
        kernelPara(i,1)=0.002;
    elseif strcmp('rbfExtend',cell2mat(kernelType(i)))
        kernelPara(i,1:2)=[0.1,0.1];
    end 
end
%% ����������
% if isempty(testData)
%     for i=1:length(kernelType)
%         Kernel{1,i}=kernelFunc(trainData,cell2mat(kernelType(i)),kernelPara(i,:));
%         normalizeKernel{1,i}=(diag(Kernel{1,i})*diag(Kernel{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
%     end
% else
%     for i=1:length(kernelType)
%         Kernel{1,i}=kernelFunc(trainData,cell2mat(kernelType(i)),kernelPara(i,:),testData);
%         Kernel_test{1,i}=kernelFunc(testData,cell2mat(kernelType(i)),kernelPara(i,:));
%         normalizeKernel{1,i}=(diag(Kernel_test{1,i})*diag(Temp{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
%     end
% end

%% �·���
Num=fix(size(trainData,2)/length(kernelType));
if isempty(testData)
    for i=1:length(kernelType)
        if i==length(kernelType)
            trainDataTemp=trainData(:,(i-1)*Num+1:end);
        else
            trainDataTemp=trainData(:,(i-1)*Num+1:Num*i);
        end
        Kernel{1,i}=kernelFunc(trainDataTemp,cell2mat(kernelType(i)),kernelPara(i,:));
        normalizeKernel{1,i}=(diag(Kernel{1,i})*diag(Kernel{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
    end
else
    for i=1:length(kernelType)
        if i==length(kernelType)
            trainDataTemp=trainData(:,(i-1)*Num+1:end);
            testDataTemp=testData(:,(i-1)*Num+1:end);
        else
            trainDataTemp=trainData(:,(i-1)*Num+1:Num*i);
            testDataTemp=testData(:,(i-1)*Num+1:Num*i);
        end
        Kernel{1,i}=kernelFunc(trainDataTemp,cell2mat(kernelType(i)),kernelPara(i,:),testDataTemp);
        Kernel_test{1,i}=kernelFunc(testDataTemp,cell2mat(kernelType(i)),kernelPara(i,:));
        normalizeKernel{1,i}=(diag(Kernel_test{1,i})*diag(Temp{1,i})').^0.5;%(k(x,x)*k(z,z)).^0.5
    end
end


kernel=zeros(length(Kernel{1,1}));
for i=1:length(kernelType)
    kernelTemp=Kernel{1,i}./normalizeKernel{1,i};
    kernel=kernel+coef(i)*kernelTemp;
end
temp=normalizeKernel;

end

