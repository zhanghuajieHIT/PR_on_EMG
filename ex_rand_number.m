% �����ܹ���ʵ��������ʵ���ߵ����������Ϊʵ���õ��������
% ����Ӧ���õ���������
% 2016/11/23
function ex_rand_number(exnumber,name)
motion_name={'����չ','������','�󲿳߲�','�����',...
    '������','������','���ץȡ','����ץȡ','Բ��ץȡ',...
    '��ָץȡ','ʳָָʾ','ǿ��ץȡ','�����ſ�','����'};
for i=1:9:9*exnumber
%     loc1=['A',num2str(i)];
%     loc2=['A',num2str(i+1)];
%     loc3=['A',num2str(i+2)];
    ex={['��',num2str((i+8)/9),'��ʵ��']};
    xlswrite('ʵ�������.xlsx',ex,name,['A',num2str(i)]);
    for k=1:2:2*4
        randnum=randperm(14)-1;
        xlswrite('ʵ�������.xlsx',randnum,name,['A',num2str(i+k)]);
        motion=cell(1,14);
        for j=1:14
            motion{1,j}=motion_name{1,randnum(j)+1};
        end       
        xlswrite('ʵ�������.xlsx',motion,name,num2str(i+k+1));
    end
end
end