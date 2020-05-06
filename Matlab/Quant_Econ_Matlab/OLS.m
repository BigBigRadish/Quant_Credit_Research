function [Beta, se, beta_low, beta_high] = OLS(y,X)
%--------------------------------------------------
% PURPOSE: perform an OLS regression
%--------------------------------------------------
% INPUTS: y: N-by-1 dependent variable
%         X: N-by-K independent variable
%--------------------------------------------------
% OUTPUT: Beta: OLS coefficient vector
%           se: standard error of beta
%--------------------------------------------------

%----- (1) Calculate the coefficients -------------

Beta   = (X'*X)\(X'*y);

%----- (2) Calculate the standard errors ----------

yhat   = X*Beta;
u      = yhat - y;
N      = length(y);
K      = size(X, 2);
sigma  = sum(u.*u)/(N-K);
v_mat  = sigma * inv(X'*X);
se     = diag(sqrt(v_mat));

%----- (3) Calculate 95 percent confidence intervals 

beta_low  = Beta - 1.96*se;
beta_high = Beta + 1.96*se;

return