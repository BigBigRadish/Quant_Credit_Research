function [TV optK] = IterateVF(V, maxK)
%---------------
% PURPOSE: take a potential value fn V and perform an iteration, returning
% the updated proposed value fn TV. When TV = V, done. The scalar maxK
% represents max possible amount of capital that can be consumed in one
% period
%---------------
% INPUTS:   V    : Nx1 vector of potential value fn
%           maxK : scalar of max capital that can be consumed in a period
%---------------
% OUTPUT:   TV   : updated value fn
%           optK : vector of optimal capital amounts
%---------------

%----- (1) Basic Parameters
Alpha = 0.65; Beta = 0.9; Theta = 1.2;

grid = length(V);
K    = linspace(1e-6, maxK, grid)';
TV   = zeros(length(V), 1);

%----- (2) Loop through and create new value function for each possible
%-----     capital value
for k = 1:grid
    c               = Theta*(K(k)^Alpha) - K(1:k);
    c(c<=0)         = 0;
    u               = log(c);
    [TV(k) optK(k)] = max(u + Beta*V(1:k));
end
end