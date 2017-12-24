% LDA self_made£¬¼ûçù¸ç´úÂë
function model = lda_zhj(X,Y)
% Input:
% X is a N*M matrix, N is the number of samples, M is the dimension
% Y is a N*1 vector, is the label vector of X
% Output:
% model is the predictive model;

% sort data into positive part and negative part
pos=Y==1;
neg=Y==-1;
N_pos=sum(pos,1);
N_neg=sum(neg,1);
X_pos=X(pos,:);
X_neg=X(neg,:);

% compute model parameters
model.mu_pos=sum(X_pos,1)/N_pos;
model.mu_neg=sum(X_neg,1)/N_neg;
sigma_pos=(X_pos-ones(N_pos,1)*model.mu_pos)'*(X_pos-ones(N_pos,1)*model.mu_pos);
sigma_neg=(X_neg-ones(N_neg,1)*model.mu_neg)'*(X_neg-ones(N_neg,1)*model.mu_neg);
model.sigma=(sigma_pos+sigma_neg)/(N_pos+N_neg-2);
model.pripos=N_pos/(N_pos+N_neg);

