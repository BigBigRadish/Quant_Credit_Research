function [capU0,capU1] = bellmanR(capU0,capU1,u0,u1,capPi,beta)

% capPi will be the transition matrix for RC, and will be a nsuppRC x
% nsuppRC matrix
nSuppX = 7;

r0 = log( exp( [capU0(:,2:nSuppX) capU0(:, nSuppX)] )+exp( [capU1(:,2:nSuppX) capU0(:, nSuppX)] ) );
r1 = log(exp(capU0(:,1))+exp(capU1(:,1)));

capU0 = u0 + beta*capPi*r0;
capU1 = u1 + beta*capPi*r1*ones(1, nSuppX);


end