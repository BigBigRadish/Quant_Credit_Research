function P = ProbitML(theta,y,x)
%--------------------------------
% PURPOSE: calculate lik fn of probit model
%--------------------------------
% USAGE: P : ProbitML(theta,y,x)
% where: theta is the parameter vector [beta; sigma]
%        y is an N-by-1 dependent variable
%        x is an N-by-k independent variable
%--------------------------------
% OUTPUT: P = log-likelihood value
%--------------------------------

%------ (1) Unpack stats --------
N    = length(y);
K    = size(x,2);

Beta = theta(1:K);

pro  = y.*(log(normcdf((Beta*x')'))) + (1-y).*(log(1 - normcdf((Beta*x')')));

%------ (2) Likelihood function
P    = sum(pro);
P    = -P;

end