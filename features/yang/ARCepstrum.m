function C=ARCepstrum(x)

% calculate the cepstrum coefficients based on ARC

N=length(x);

feat   =    arburg( x,5);
AR=feat(2:6);

C1 = - AR(1);

C2 = - AR(2) -  (1-1/2) *AR(1)*C1;

C3 = - AR(3)  - ( (1-1/3)*AR(1)*C2+(1-2/3)*AR(2)*C1);

C4 = - AR(4)  - ( (1-1/4)*AR(1)*C3+ (1-2/4)*AR(2)*C2+  (1-3/4)*AR(3)*C1);

C5 = - AR(4)  - ( (1-1/5)*AR(1)*C4+ (1-2/5)*AR(2)*C3+  (1-3/5)*AR(3)*C2+ (1-4/5)*AR(4)*C1);

C   =    [C1 C2 C3 C4 C5];