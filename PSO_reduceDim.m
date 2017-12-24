function featIndex=PSO_reduceDim
% 二进制PSO算法

global featReduceDim
c1=1.49445;
c2=1.49445;
maxGen=100;
sizePop=10;
popMax=10^(-4);
popMin=0;
% Vmax=0.0001;
% Vmin=-0.0001;
Vmax=1;
Vmin=-1;

% 种群初始化
x=zeros(sizePop,featReduceDim);
for i=1:sizePop
%     for ii=1:featReduceDim
%         if rand()>0.5
%             x(i,ii)=1;
%         end
%     end
    initPop(i,:)=(10^(-5))*10*rand(1,featReduceDim);%产生[0,10]*10^(-5)内的随机初始值
%     V(i,:)=rands(1,featDim)*(10^(-4));%初始化速度
    V(i,:)=rands(1,featReduceDim);
    for ii=1:featReduceDim
        s( i , ii ) = 1/(1+exp( V (i , ii )));
        if rand()>s( i , ii )
            x(i,ii)=1;
        end
    end
end
fitness=fitPSO_reduceDim(x);
    
% 寻找初始极值
[bestFitness,bestIndex]=min(fitness);
zbest=initPop(bestIndex,:);
xbest=x(bestIndex,:);
gbest=initPop;
fitnessgbest=fitness;
fitnesszbest=bestFitness;

% 迭代寻优
for i=1:maxGen
    s=[];
    for j=1:sizePop
        %速度更新
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - initPop(j,:)) + c2*rand*(zbest - initPop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %种群更新
        initPop(j,:)=initPop(j,:)+0.5*V(j,:);
        initPop(j,find(initPop(j,:)>popMax))=popMax;
        initPop(j,find(initPop(j,:)<popMin))=popMin;
        
        for ii=1:featReduceDim
            s( j , ii ) = 1/(1+exp( V (j , ii )));
            if rand()>s( j , ii )
                x(j,ii)=1;
            else
                x(j,ii)=0;
            end
        end
        
        
%         if rand>0.95
%             initPop(j,:)=(10^(-5))*10*rand(1,featDim);
%         end
        
        %适应度值
        fitness(j)=fitPSO_reduceDim(x(j,:)); 
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
            xbest=x(j,:);
            fitnesszbest = fitness(j);
        end
    end     
    
%     yy(i)=fitnesszbest;
end
[~,featIndex]=find(xbest==1);




end


