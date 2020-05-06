function Q = GMMObjective(Beta,y,X)
%---------------------------------------
% PURPOSE: calculate moments of a linear regression model.
% True Method of Moments estimate of beta when Q=0.
%
% The series of moments fitted are: [E(X_1*u)=0 E(X_2*u)=0...
% E(X_k*u)=0]
%---------------------------------------
% USAGE: Q: GMMObjective(Beta,y,X)
% where: Beta: parameter vector
%        y: N-by-1 dependent variable
%        X: N-by-K independent variable
%---------------------------------------
% OUTPUT: Q: value of moment conditions
%---------------------------------------

%------ (1) determine sample size N and number of coefficients K

N = length(y);
K = size(X, 2);

%------ (2) Calculate u and generate the identity weight matrix

u = y - X*Beta;
W = eye(K);

%------ (3) Generate moment vector ------

m = (1/N)*u'*X;
Q = m*W*m';

end