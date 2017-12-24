function predict_label = SVM_MultiClass_1vs1(x,model)
% ������࣬��1vs1����
% ����model��֧�������Ͳ�����
% xΪ���ݵĲ�������

gamma = model.Parameters(4);
RBF = @(u,v)( exp(-gamma.*sum( (u-v).^2,2)) );%����rbf����
 
NUM=1;
classNum=model.nr_class;
labelTemp=zeros(1,classNum);
for ii=1:classNum-1
    count=ii;
    for jj=ii+1:classNum
        startIndex_ii=sum(model.nSV(1:ii-1))+1;
        endIndex_ii=sum(model.nSV(1:ii));
        startIndex_jj=sum(model.nSV(1:jj-1))+1;
        endIndex_jj=sum(model.nSV(1:jj));
        u=[model.SVs(startIndex_ii:endIndex_ii,:);model.SVs(startIndex_jj:endIndex_jj,:)];%ii vs jj ʱ��֧������
        num=jj-ii-1;
        coef=[model.sv_coef(startIndex_ii:endIndex_ii,count);model.sv_coef(startIndex_jj:endIndex_jj,count-num)];
        count=count+1;
        v=ones(size(coef,1),1)*x;
        y=sum(coef.*RBF(u,v));
        b=-model.rho(NUM);
        NUM=NUM+1;
        y=y+b;
        if y>=0
            labelNum=ii;
        else
            labelNum=jj;
        end
        labelTemp(labelNum)=labelTemp(labelNum)+1;
    end
end
[~,predict_label]=max(labelTemp);

