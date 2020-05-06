function V = FlowUtility(T, Beta, C)
%-------------------------------------
% PURPOSE: calculate total u of c with additively
% separable u fn. and discount rate Beta.
%-------------------------------------
% INPUTS:  C: Tx1 vector of indep variable
%          T: scalar time
%          
%          Beta: discount rate
%-------------------------------------
% OUTPUT:  V: -utility
%-------------------------------------

c = C(:, 1);

t = [1:1:T];
V = Beta.^(t-1)*log(c);
V = -V;

end