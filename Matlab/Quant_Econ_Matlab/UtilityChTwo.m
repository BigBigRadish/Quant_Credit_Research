function u = UtilityChTwo(X)
%--------------------------------------
% PURPOSE: calculate utility, C-D
%--------------------------------------
% USAGE: u: Utility
% where: x1: quantity of q1
%        x2: quantity of q2
%--------------------------------------
% OUTPUT: u: overall utility
%--------------------------------------

x1 = X(1);
x2 = X(2);
u = -(x1^0.5) * (x2^(0.5));

end