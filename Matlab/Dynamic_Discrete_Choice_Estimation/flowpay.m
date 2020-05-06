function [u0, u1] = flowpay(supportX, supportRC, thetaone, theta)

% supportX and supportRC will be column vectors

nsuppX  = size(supportX, 1);
nsuppRC = size(supportRC, 1); 

% Utility of not replacing, i.e. a=0
% Depends on X today

u0 = (supportX.*(-thetaone))';
u0 = repmat(u0, nsuppRC, 1);

% u0 is a nsuppRC * nusppX matrix

% Utility of replacing, i.e. a=1
u1 = (supportRC.*(-theta));
u1 = repmat(u1, 1, nsuppX);

% u1 is also a nsuppRC * nusppX matrix

end