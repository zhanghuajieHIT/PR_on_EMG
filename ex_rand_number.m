% 输入总共的实验组数和实验者的姓名，输出为实验用到的随机数
% 姓名应该用单引号引起。
% 2016/11/23
function ex_rand_number(exnumber,name)
motion_name={'腕部伸展','腕部弯曲','腕部尺侧','腕部桡侧',...
    '腕部内旋','腕部外旋','侧边抓取','球形抓取','圆柱抓取',...
    '三指抓取','食指指示','强力抓取','手掌张开','放松'};
for i=1:9:9*exnumber
%     loc1=['A',num2str(i)];
%     loc2=['A',num2str(i+1)];
%     loc3=['A',num2str(i+2)];
    ex={['第',num2str((i+8)/9),'组实验']};
    xlswrite('实验随机数.xlsx',ex,name,['A',num2str(i)]);
    for k=1:2:2*4
        randnum=randperm(14)-1;
        xlswrite('实验随机数.xlsx',randnum,name,['A',num2str(i+k)]);
        motion=cell(1,14);
        for j=1:14
            motion{1,j}=motion_name{1,randnum(j)+1};
        end       
        xlswrite('实验随机数.xlsx',motion,name,num2str(i+k+1));
    end
end
end