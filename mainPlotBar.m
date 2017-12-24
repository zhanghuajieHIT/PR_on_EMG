%% ������״ͼ��������
% ��״ͼ������׼��
% ����excel������
% ��Ҫ�½�һ��excel���ר������������
clc;
clear;
close all;

%------------�޸�����-----------------%
%��Ҫ���Ƶ����ݣ��确��ֵ��������׼�
objData={'��ֵ','��׼��'};
xrange=[];%x��ķ�Χ
yrange=[0,75];%y��ķ�Χ
% ��״ͼλ���趨����Ҫ���ݾ���͵���ȷ��
% ÿ������4С��ʱ��[-3:2:3]*0.09;
% ÿ������2С��ʱ��[-1:2:1]*0.14;
% ֻ��1���飬��С��ʱ��[1]*0.01;
% ÿ������6С��ʱ��[-4.2:1.675:4.175]*0.08;
% ÿ������8С��ʱ��[-3.5:1:3.5]*0.1;
picLoc=[1]*0.01;
flag=1;%flag=1��������ı�ǩ����Ϊб�ģ�flag=0�����Ժ�����ı�ǩ����
%---------------------------------------%
[data,textSaved]=xlsread('bar.xlsx');
objLoc=[];
for i=1:length(objData)
    objLoc_temp=strcmp(textSaved(1,:),objData(i));
    objLoc=cat(1,objLoc,objLoc_temp);
end
[~,objCol]=find(objLoc);%�ҵ�objData���е�λ��
feat_compare=textSaved(2:end,1)';
method_compare=textSaved(1,2:objCol(2)-2);

%�ҵ���ֵ�ͷ���λ��
[~,nanCol]=find(isnan(data(1,:)));%�ҵ�mean��std���ݵķֽ�λ��
meanData=data(:,1:nanCol(1)-1);
stdData=data(:,nanCol(2)+1:end);
if size(meanData,1)==1
    bar(meanData);
else
    X=1:size(meanData,1);
    bar(X,meanData,0.8);%������ֵ����״ͼ
end
if ~isempty(xrange)&&~isempty(yrange)
    axis([xrange,yrange]);
elseif isempty(xrange)&&~isempty(yrange)
    ylim(yrange);
elseif isempty(yrange)&&~isempty(xrange)
    xlim(xrange);
end
hold on;
Y=[1:size(meanData,1)]'*ones(1,size(meanData,2))+ones(size(meanData,1),1)*picLoc;
errorbar(Y,meanData,stdData,'Marker','none','LineStyle','none');
legend(method_compare,'FontSize',21);
set(gca,'XTick',[1:length(meanData)],'XTickLabel',feat_compare,'FontSize',20);

if flag==1
    xtb = get(gca,'XTickLabel');   % ��ȡ���������ǩ���
    xt = get(gca,'XTick');   % ��ȡ��������̶Ⱦ��
    yt = get(gca,'YTick');    % ��ȡ��������̶Ⱦ��      
    xtextp=xt;    %ÿ����ǩ����λ�õĺ����꣬�����ȻӦ�ú�ԭ����һ���ˡ�
    % ������ʾ��ǩ��λ�ã�д����Ψһ��������ʵ����Ϊÿ����ǩ�ҷ���λ�õ�������                     
    ytextp=yt(1)*ones(1,length(xt)); 
    % rotation��������ת�Ƕȴ�����ʱ����ת����ת�������HorizontalAlignment�������趨��
    % ��3������ֵ��left��right��center��������Ը�������ֵ���Լ�rotation��ĽǶȣ�����д����45
    % ��ͬ�ĽǶȶ�Ӧ��ͬ����תλ���ˣ����Լ�����������ˡ�
    % ytextp - 0.5���ñ�ǩ��΢��һ��һ�㣬�Եò���ô����
    text(xtextp,ytextp-0.5,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',15); 
    set(gca,'xticklabel','');% ��ԭ�еı�ǩ��ȥ
end
xlabel('����','FontSize',22);
ylabel('ʶ����ȷ�ʣ�%��','FontSize',22);
title('����ʶ����ȷ�ʶԱ�','FontSize',22);

