function s = sur(g,r)
%----------------------------
% Purpose: calculate consumer surplus from having insurance

mu         = 0;
sigma      = 1;
exp_u      = -exp(0.5.*(sigma^2).*(r.^2)-mu.*r);
a=(g-mu)./sigma;
exp_u_ins  = -exp(0.5.*(sigma^2).*(r.^2)-mu.*r).*((1-normcdf(a+sigma.*r))./(1-normcdf(a)));

s          = exp_u_ins - exp_u;

end