function TDPSDm=feature_TDPSDm(y)
% TDPSD特征的改进
% Modifications
% 23/06/2004   AC: template created http://www.sce.carleton.ca/faculty/chan/index.php?page=matlab
% 17/11/2013   RK: Spectral moments first created.
% 01/03/2014   AT: Rami Sent me this on 1-3-14 to go with normalised KSM_V1

% References
% [1] A. Al-Timemy, R. N. Khushaba, G. Bugmann, and J. Escudero, "Improving the Performance Against Force Variation of EMG Controlled Multifunctional Upper-Limb Prostheses for Transradial Amputees", 
%     IEEE Transactions on Neural Systems and Rehabilitation Engineering, DOI: 10.1109/TNSRE.2015.2445634, 2015.
% [2] R. N. Khushaba, Maen Takruri, Jaime Valls Miro, and Sarath Kodagoda, "Towards limb position invariant myoelectric pattern recognition using time-dependent spectral features", 
%     Neural Networks, vol. 55, pp. 42-58, 2014. 

ebp=feature_TDPSD(y);
efp=feature_TDPSD(log(y.^2+eps));
num = -2.*ebp.*efp;
den = efp.*efp+ebp.*ebp;
TDPSDm= num./den;

end

