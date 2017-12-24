function thresh=PSO_FeatPara_EX
% PSO优化特征参数

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
% 种群初始化
for i=1:sizePop
%     initPop(i,:)=(10^(-5))*10*rand(1,featDim);%产生[0,10]*10^(-5)内的随机初始值
    initPop(i,:)=[0.000015,0.000015,0.000015,0.000015,0.000015,0.000015,0.00001,0.000015];
    V(i,:)=rands(1,featDim)*(10^(-4));%初始化速度
%     V(i,:)=rands(1,featDim);
end
fitness=fitPSO_EX(initPop);
    
% 寻找初始极值
[bestFitness,bestIndex]=min(fitness);
zbest=initPop(bestIndex,:);
gbest=initPop;
fitnessgbest=fitness;
fitnesszbest=bestFitness;

% 迭代寻优
for i=1:maxGen
    for j=1:sizePop
        %速度更新
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - initPop(j,:)) + c2*rand*(zbest - initPop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %种群更新
        initPop(j,:)=initPop(j,:)+0.5*V(j,:);
        initPop(j,find(initPop(j,:)>popMax))=popMax;
        initPop(j,find(initPop(j,:)<popMin))=popMin;
        
%         if rand>0.95
%             initPop(j,:)=(10^(-5))*10*rand(1,featDim);
%         end
        
        %适应度值
        fitness(j)=fitPSO_EX(initPop(j,:)); 
    end
    
    for j=1:sizePop
        
        %个体最优更新
        if fitness(j) < fitnessgbest(j)
            gbest(j,:) = initPop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        %群体最优更新
        if fitness(j) < fitnesszbest
            zbest = initPop(j,:);
            fitnesszbest = fitness(j);
        end
    end     
    
    yy(i)=fitnesszbest;
end
thresh=zbest;

end