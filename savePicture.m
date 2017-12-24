load('E:\ICIRA\a1.mat')
for i=1:8
    plot(dataStructure.rawEMG(:,i));
    saveas(gcf,['a1_',num2str(i)],'emf');
end