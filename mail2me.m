%Ϊ�˱��ܣ���д�ó�����������д�����Ҫ����pcode mail2me������
%��ʹɾ��mail2me.m�ļ�Ҳ�������С�������Ϊ���ù�pcode���������
%�Ժ��޸Ĺ�mail2me��Ҳ��Ҫ����һ��pcode mail2me
function mail2me(subject,content) 
MailAddress = 'zhanghuajie001@163.com'; 
password = 'qqxin1992';   
setpref('Internet','E_mail',MailAddress); 
setpref('Internet','SMTP_Server','smtp.163.com'); 
setpref('Internet','SMTP_Username',MailAddress); 
setpref('Internet','SMTP_Password',password); 
props = java.lang.System.getProperties; 
props.setProperty('mail.smtp.auth','true'); 
sendmail('310336422@qq.com',subject,content);

%% ���͸���
% DataPath ='C:\Users\zhj\Desktop\Python�ʼ�.docx';%�ļ�·��
% sendmail('310336422@qq.com',subject,content,DataPath);

end