function TDPSD=feature_TDPSD(y)
% Time-domain power spectral moments (TD-PSD)
% Using Fourier relations between time domina and frequency domain to
% extract power spectral moments dircetly from time domain.
%
% Modifications
% 17/11/2013  RK: Spectral moments first created.
% 02/03/2014  AT: I added 1 to the function name to differentiate it from other versions from Rami
% 
% References
% [1] A. Al-Timemy, R. N. Khushaba, G. Bugmann, and J. Escudero, "Improving the Performance Against Force Variation of EMG Controlled Multifunctional Upper-Limb Prostheses for Transradial Amputees", 
%     IEEE Transactions on Neural Systems and Rehabilitation Engineering, DOI: 10.1109/TNSRE.2015.2445634, 2015.
% [2] R. N. Khushaba, Maen Takruri, Jaime Valls Miro, and Sarath Kodagoda, "Towards limb position invariant myoelectric pattern recognition using time-dependent spectral features", 
%     Neural Networks, vol. 55, pp. 42-58, 2014. 

%% Get the size of the input signal
[samples,channels]=size(y);

if channels>samples
    y  = y';
    [samples,channels]=size(y);
end

%S=S- repmat(mean(S),samples,1);% zero mean 
%not needed


%% Root squared zero order moment normalized
m0     = sqrt(sum(y.^2));
m0     = m0.^.1/.1;

% Prepare derivatives for higher order moments
d1     = diff([zeros(1,channels);diff(y)],1,1);%2nd derivative%效果较好
d2     = diff([zeros(1,channels);diff(d1)],1,1);%4th derivative

%d1     = diff([zeros(1,channels);S],1,1);%1nd derivative Rocky  07/11/2016
%d2     = diff([zeros(1,channels);d1],1,1);%2th derivative Rocky 07/11/2016


% Root squared 2nd and 4th order moments normalized
m2     = sqrt(sum(d1.^2));
m2     = m2.^.1/.1;

m4     = sqrt(sum(d2.^2));
m4     = m4.^.1/.1;

%% Sparseness
sparsi = (sqrt(abs((m0-m2).*(m0-m4))).\m0);

%% Irregularity Factor
IRF    = m2./sqrt(m0.*m4);

%% Waveform length ratio
WLR    = sqrt(sum(abs(d1))./sum(abs(d2)));
% 论文中
% WLR    = (sum(abs(d1))./sum(abs(d2)));%效果一样

%% All features together
TDPSD=log(abs([(m0),(m0-m2),(m0-m4),sparsi,IRF,WLR]));

end

