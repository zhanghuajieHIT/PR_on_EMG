%
% getTDPSDfeatv1 get Khushaba's modified Time Domian Spectral Moments (TD-PSD) feature.
%
% feat = getksmfeat(x,winsize,wininc,datawin,dispstatus)
%
% Author Rami Khushaba & Ali. Al-Timemy
%
% This function computes the time-domain spectral moments feature of the signals in x,
% x is made of columns, each representing a channel/sensor. 
% For example if you get 5 sec of data from 8 channels/sensors at 1000 Hz 
% then x should be 5000 x 8. A windowing scheme is used here to extract features 
%
% The signals in x are divided into multiple windows of size
% winsize and the windows are spaced wininc apart.
%
%
% Inputs
%    x: 		columns of signals
%    winsize:	window size (length of x)
%    wininc:	spacing of the windows (winsize)
%    datawin:   window for data (e.g. Hamming, default rectangular)
%               must have dimensions of (winsize,1)
%    dispstatus:zero for no waitbar (default)
%
% Outputs
%    feat:     Spectral momements (6 features per channel)
%              dim1 window
%              dim2 feature
%
% Modifications
% 23/06/2004   AC: template created http://www.sce.carleton.ca/faculty/chan/index.php?page=matlab
% 17/11/2013   RK: Spectral moments first created.
% 01/03/2014   AT: Rami Sent me this on 1-3-14 to go with normalised KSM_V1

% References
% [1] A. Al-Timemy, R. N. Khushaba, G. Bugmann, and J. Escudero, "Improving the Performance Against Force Variation of EMG Controlled Multifunctional Upper-Limb Prostheses for Transradial Amputees", 
%     IEEE Transactions on Neural Systems and Rehabilitation Engineering, DOI: 10.1109/TNSRE.2015.2445634, 2015.
% [2] R. N. Khushaba, Maen Takruri, Jaime Valls Miro, and Sarath Kodagoda, "Towards limb position invariant myoelectric pattern recognition using time-dependent spectral features", 
%     Neural Networks, vol. 55, pp. 42-58, 2014. 

function feat = getTDPSDfeatv1(x,winsize,wininc,datawin,dispstatus)

if nargin < 5
    if nargin < 4
        if nargin < 3
            if nargin < 2
                winsize = size(x,1);
            end
            wininc = winsize;
        end
        datawin = ones(winsize,1);
    end
    dispstatus = 0;
end

datasize = size(x,1);
Nsignals = size(x,2);
numwin = floor((datasize - winsize)/wininc)+1;

% allocate memory
feat = zeros(numwin-1,Nsignals*6);

if dispstatus
    h = waitbar(0,'Computing KSM features...');
end

st = 1;
en = winsize;
for i = 1:numwin
   
   curwin = x(st:en,:).*repmat(datawin,1,Nsignals);
   
   % Step1: Extract features from original signal and a nonlinear version of it
   ebp=KSM1(curwin);
   efp=KSM1(log(curwin.^2+eps));
   
   % Step2: Correlation analysis
   num = -2.*ebp.*efp;
   den = efp.*efp+ebp.*ebp;
   
   % feature extraction goes here
   feat(i,:) = num./den;
   st = st + wininc;
   en = en + wininc;
end

if dispstatus
    close(h)
end



function Feat = KSM1(S)
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
[samples,channels]=size(S);

if channels>samples
    S  = S';
    [samples,channels]=size(S);
end

%% Root squared zero order moment normalized
m0     = sqrt(sum(S.^2));
m0     = m0.^.1/.1;

% Prepare derivatives for higher order moments
d1     = diff([zeros(1,channels);diff(S)],1,1);
d2     = diff([zeros(1,channels);diff(d1)],1,1);

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

%% All features together
Feat   = log(abs([(m0) (m0-m2) (m0-m4) sparsi IRF WLR]));

