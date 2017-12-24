function bestSpread=GA_PNN
%% GA优化PNN的参数
% clc;clear;
warning off;
% popu=100;
popu=20;
bounds=ones(1,1)*[0.1,10];
gen=100;
initPop=initializega(popu,bounds,'fitness_PNN',1);
[X,endPop,bPop,trace]=gaot_ga(bounds,'fitness_PNN',[],initPop,[1e-6 1 0],'maxGenTerm',...
    gen,'normGeomSelect',0.09,'simpleXover',2,'boundaryMutation',[2 gen 3]);

bestSpread=X(1);

end

