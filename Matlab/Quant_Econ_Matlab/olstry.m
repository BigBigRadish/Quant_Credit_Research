clc;
clear all;

DataIn = dlmread('C:\Users\Haritz\Desktop\Haritz Git\Matlab_book\auto.csv');
y      = DataIn(:,1);
X      = DataIn(:, 2:3);
size(X)
X      = [X, ones(74,1)];

XX=X'*X;
Xy=X'*y;
BetaHat=(inv(XX))*Xy

[OLS_Beta,OLS_se, CIl, CIh]=OLS(y,X);
[OLS_Beta,OLS_se, CIl, CIh]

%---------------------------
% Now we try the Utility function

[x1, x2] = meshgrid([0:0.1:3], [0:0.1:3]);
u        = Utility(x1, x2, 0.1);
surfc(x1, x2, u)

%----------------------------------
% Consumer surplus exercise from Chapter 1, ex. 4d

[g, r]   = meshgrid([-3:0.1:3], [0:0.1:1.5]);
surplus  = sur(g,r);
surfc(g, r, surplus)

