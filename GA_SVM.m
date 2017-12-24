function bestC_G=GA_SVM
%% GA优化SVM的c,g参数
% clc;clear;
warning off;
% popu=100;
popu=20;
bounds=ones(2,1)*[0.01,100];
gen=100;
initPop=initializega(popu,bounds,'fitness_SVMcg',1);
[X,endPop,bPop,trace]=gaot_ga(bounds,'fitness_SVMcg',[],initPop,[1e-6 1 0],'maxGenTerm',...
    gen,'normGeomSelect',0.09,'simpleXover',2,'boundaryMutation',[2 gen 3]);

bestC_G=X(1:2);

end

