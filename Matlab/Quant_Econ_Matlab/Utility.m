function u = Utility(x1,x2,alpha)
%--------------------------------------
% PURPOSE: calculate utility, C-D
%--------------------------------------
% USAGE: u: Utility
% where: x1: quantity of q1
%        x2: quantity of q2
%--------------------------------------
% OUTPUT: u: overall utility
%--------------------------------------

u = (x1.^alpha) .* (x2.^(1-alpha));

end