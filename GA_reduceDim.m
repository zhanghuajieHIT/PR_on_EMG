function featIndex=GA_reduceDim
%基于GA的特征降维

warning off;
global featReduceDim
% popu=100;
popu=20;
bounds=ones(featReduceDim,1)*[0,1];
% initPop=initializega(popu,bounds,'fitness_reduceDim');%这样出现的initPop不是整数
initPop=randi([0,1],popu,featReduceDim);
initFit=zeros(popu,1);
for i=1:size(initPop,1)
    initFit(i)=deCode(initPop(i,:));    
end
initPop=[initPop initFit];
gen=100;

[X,endPop,bPop,trace]=gaot_ga(bounds,'fitness_reduceDim',[],initPop,[1e-6 1 0],'maxGenTerm',...
    gen,'normGeomSelect',0.09,'simpleXover',2,'boundaryMutation',[2 gen 3]);
[~,featIndex]=find(X==1);


end