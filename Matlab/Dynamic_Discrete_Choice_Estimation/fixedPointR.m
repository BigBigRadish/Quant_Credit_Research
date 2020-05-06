function [capU0,capU1] = fixedPointR(u0,u1,capPi,beta,tolFixedPoint,bellmanR,capU0,capU1)

nSuppRC = size(capPi,1);
nSuppX  = size(u0, 2);

if isempty(capU0) 
	capU0 = zeros(nSuppRC, nSuppX);
end
if isempty(capU1)
	capU1 = zeros(nSuppRC, nSuppX);
end

inU0 = capU0+2*tolFixedPoint;
inU1 = capU1+2*tolFixedPoint;
while (max(max(abs(inU0-capU0)))>tolFixedPoint) || (max(max(abs(inU1-capU1)))>tolFixedPoint);
	inU0 = capU0;
	inU1 = capU1;
	[capU0,capU1] = bellmanR(inU0,inU1,u0,u1,capPi,beta);
end

end