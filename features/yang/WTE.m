function Feat=WTE(S)

% S: EMG signal supposed to be Samples X Channels
% Feat: Feature matrix, supposed to be Channes X feature dimension

[samples,channels]=size(S);

if channels>samples
    S  = S';
    [samples,channels]=size(S);
    
end

%S  =   S - repmat(mean(S),samples,1);% zero mean

for i=1:channels;
    
    tempsig  =    S(:,i);%ith channel

    [c,l]    =    wavedec(tempsig,5,'sym8');%
    [ea,ed]  =    wenergy(c,l);
  % Feat(i,:)=    [ea,ed];% energy percentage within each node

    E        =    sum(tempsig.^2);% the energy of the signal
    F        =    [ea ed];
    Feat(i,:)=    F/100*E;% using the pure energy but not the percentages

end




