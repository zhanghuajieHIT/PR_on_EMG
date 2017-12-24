function thresh=GA_FeatPara
%% GA优化特征的参数
% clc;clear;
warning off;
global featDim
% popu=100;
popu=20;
bounds=(10^(-6))*ones(featDim,1)*[0,100];
gen=100;
initPop=initializega(popu,bounds,'fitness_FeatPara',1);
[X,endPop,bPop,trace]=gaot_ga(bounds,'fitness_FeatPara',[],initPop,[1e-6 1 0],'maxGenTerm',...
    gen,'normGeomSelect',0.09,'simpleXover',2,'boundaryMutation',[2 gen 3]);
% thresh=roundn(X(1:featDim),-7);
thresh=X(1:featDim);

