%为了保密，在写好程序后在命令行窗口需要运行pcode mail2me，这样
%即使删除mail2me.m文件也可以运行。另外因为有用过pcode函数，因此
%以后修改过mail2me后也需要运行一次pcode mail2me
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

%% 发送附件
% DataPath ='C:\Users\zhj\Desktop\Python笔记.docx';%文件路径
% sendmail('310336422@qq.com',subject,content,DataPath);

end