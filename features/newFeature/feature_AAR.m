function AAR=feature_AAR(y)
% AAR:adaptive autoregressive
% y:256*8


[R,C]=size(y);
aMode=1;
vMode=2;
arg3=[6,0];
arg4=0.005;
arg5=[0,0,0,0,0,0];
arg6=0.1*eye(6);

MOP=arg3;
p=MOP(1); 
q=MOP(2); 
MOP=p+q;
UC= arg4;             
a0=arg5;  
A0= arg6;
TH=3;

%       TH=TH*var(y);
%        TH=TH*mean(detrend(y,0).^2);
MSY=mean(detrend(y,0).^2);

e=zeros(R,1);
Q=zeros(R,1);
V=zeros(R,1);
T=zeros(R,1);
%DET=zeros(nc,1);
SPUR=zeros(R,1);
ESU=zeros(R,1);
a=a0(ones(R,1),:);
%a=zeros(nc,MOP);
%b=zeros(nc,q);

mu=1-UC; % Patomaeki 1995
lambda=(1-UC); % Schloegl 1996
arc=poly((1-UC*2)*[1;1]);
b0=sum(arc); % Whale forgettting factor for Mode=258,(Bianci et al. 1997)

dW=UC/MOP*eye(MOP);                % Schloegl



%------------------------------------------------
%	First Iteration
%------------------------------------------------
Y=zeros(MOP,1);
C=zeros(MOP);
%X=zeros(q,1);
at=a0;
A=A0;
E=y(1);
e(1)=E;
V(1)=(1-UC)+UC*E*E;
ESU(1)= 1; %Y'*A*Y;

A1=zeros(MOP);
A2=A1;

%------------------------------------------------
%	Update Equations
%------------------------------------------------
T0=2;
        
for t=T0:R,
       
        %Y=[y(t-1); Y(1:p-1); E ; Y(p+1:MOP-1)]
        
        if t<=p 
            Y(1:t-1)=y(t-1:-1:1);           % Autoregressive 
        else
            Y(1:p)=y(t-1:-1:t-p);
            
        end
        
        if t<=q 
            Y(p+(1:t-1))=e(t-1:-1:1);       % Moving Average
        else
            Y(p+1:MOP)=e(t-1:-1:t-q);
        end
        
        % Prediction Error 
        E = y(t) - a(t-1,:)*Y;
        e(t) = E;
        E2=E*E;
        
        AY=A*Y; 
        V(t) = V(t-1)*(1-UC)+UC*E2;        
        esu=Y'*AY;
        ESU(t)=esu;
                  
        if aMode == -1, % LMS 
                %	V(t) = V(t-1)*(1-UC)+UC*E2;        
                a(t,:)=a(t-1,:) + (UC/MSY)*E*Y';
        elseif aMode == -2 % LMS with adaptive estimation of the variance 
                a(t,:)=a(t-1,:) + UC/V(t)*E*Y';

        else    % Kalman filtering (including RLS) 
                if vMode==1, 		%eMode==4
                        Q(t) = (esu + V(t));      
                elseif vMode==2, 	%eMode==2
                        Q(t) = (esu + 1);          
                elseif vMode==3, 	%eMode==3
                        Q(t) = (esu + lambda);     
                elseif vMode==4, 	%eMode==1
                        Q(t) = (esu + V(t-1));           
                elseif vMode==5, 	%eMode==6
                        if E2>esu 
                                V(t)=(1-UC)*V(t-1)+UC*(E2-esu);
                        else 
                                V(t)=V(t-1);
                        end;
                        Q(t) = (esu + V(t));           
                elseif vMode==6, 	%eMode==7
                        if E2>esu 
                                V(t)=(1-UC)*V(t-1)+UC*(E2-esu);
                        else 
                                V(t)=V(t-1);
                        end;
                        Q(t) = (esu + V(t-1));           
                elseif vMode==7, 	%eMode==8
                        Q(t) = esu;
                end;
        
                k = AY / Q(t);		% Kalman Gain
                a(t,:) = a(t-1,:) + k'*E;
                
                if aMode==1, 			%AMode=1
                        A = (1+UC)*(A - k*AY');                   % Schloegl et al. 1997
                elseif aMode==2, 		%AMode=11
                        A = A - k*AY';
                        A = A + sum(diag(A))*dW;
                elseif aMode==3, 		%AMode=5
                        A = A - k*AY' + sum(diag(A))*dW;
                elseif aMode==4, 		%AMode=6
                        A = A - k*AY' + UC*eye(MOP);               % Schloegl 1998
                elseif aMode==5, 		%AMode=2
                        A = A - k*AY' + UC*UC*eye(MOP);
                elseif aMode==6, 		%AMode=2
                        T(t)=(1-UC)*T(t-1)+UC*(E2-Q(t))/(Y'*Y);  
                        A=A*V(t-1)/Q(t);  
                        if T(t)>0 A=A+T(t)*eye(MOP); end;          
                elseif aMode==7, 		%AMode=6
                        T(t)=(1-UC)*T(t-1)+UC*(E2-Q(t))/(Y'*Y);      
                        A=A*V(t)/Q(t);  
                        if T(t)>0 A=A+T(t)*eye(MOP); end;          
                elseif aMode==8, 		%AMode=5
                        Q_wo = (Y'*C*Y + V(t-1));                
                        C=A-k*AY';
                        T(t)=(1-UC)*T(t-1)+UC*(E2-Q_wo)/(Y'*Y);      
                        if T(t)>0 A=C+T(t)*eye(MOP); else A=C; end;          
                elseif aMode==9, 		%AMode=3
                        A = A - (1+UC)*k*AY';
                        A = A + sum(diag(A))*dW;
                elseif aMode==10, 		%AMode=7
                        A = A - (1+UC)*k*AY' + sum(diag(A))*dW;
                elseif aMode==11, 		%AMode=8
                        A = A - (1+UC)*k*AY' + UC*eye(MOP);        % Schloegl 1998
                elseif aMode==12, 		%AMode=4
                        A = A - (1+UC)*k*AY' + UC*UC*eye(MOP);
                elseif aMode==13
                        A = A - k*AY' + UC*diag(diag(A));
                elseif aMode==14
                        A = A - k*AY' + (UC*UC)*diag(diag(A));
                end;
        end;
end;
%a=a(end,:);


% REV = (e'*e)/(y'*y);


AAR=a(end,:);



end


