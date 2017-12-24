function thresh=PSO_FeatPara_EX
% PSO�Ż���������

global featDim
c1=1.49445;
c2=1.49445;
maxGen=50;
sizePop=10;
popMax=10^(-4);
popMin=0;
Vmax=0.0001;
Vmin=-0.0001;
featDim=8;
% ��Ⱥ��ʼ��
for i=1:sizePop
%     initPop(i,:)=(10^(-5))*10*rand(1,featDim);%����[0,10]*10^(-5)�ڵ������ʼֵ
    initPop(i,:)=[0.000015,0.000015,0.000015,0.000015,0.000015,0.000015,0.00001,0.000015];
    V(i,:)=rands(1,featDim)*(10^(-4));%��ʼ���ٶ�
%     V(i,:)=rands(1,featDim);
end
fitness=fitPSO_EX(initPop);
    
% Ѱ�ҳ�ʼ��ֵ
[bestFitness,bestIndex]=min(fitness);
zbest=initPop(bestIndex,:);
gbest=initPop;
fitnessgbest=fitness;
fitnesszbest=bestFitness;

% ����Ѱ��
for i=1:maxGen
    for j=1:sizePop
        %�ٶȸ���
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - initPop(j,:)) + c2*rand*(zbest - initPop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %��Ⱥ����
        initPop(j,:)=initPop(j,:)+0.5*V(j,:);
        initPop(j,find(initPop(j,:)>popMax))=popMax;
        initPop(j,find(initPop(j,:)<popMin))=popMin;
        
%         if rand>0.95
%             initPop(j,:)=(10^(-5))*10*rand(1,featDim);
%         end
        
        %��Ӧ��ֵ
        fitness(j)=fitPSO_EX(initPop(j,:)); 
    end
    
    for j=1:sizePop
        
        %�������Ÿ���
        if fitness(j) < fitnessgbest(j)
            gbest(j,:) = initPop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        %Ⱥ�����Ÿ���
        if fitness(j) < fitnesszbest
            zbest = initPop(j,:);
            fitnesszbest = fitness(j);
        end
    end     
    
    yy(i)=fitnesszbest;
end
thresh=zbest;

end