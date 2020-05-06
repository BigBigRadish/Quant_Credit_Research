function nll = negLogLikR(choices,iX,supportX,iRC,supportRC,capPi,beta,thetaone,theta,flowpay,bellmanR,fixedPointR,tolFixedPoint)
     
nSuppX  = size(supportX, 1);
nSuppRC = size(supportRC, 1);

[u0,u1]       = flowpay(supportX, supportRC, thetaone, theta);
[capU0,capU1] = fixedPointR(u0,u1,capPi,beta,tolFixedPoint,bellmanR,[],[]);
deltaU        = capU1-capU0;
pNotReplace   = 1./(1+exp(deltaU));

laggedChoices = [zeros(1,size(choices,2));choices(1:end-1,:)];
p             = choices + (1-2.*choices).*pNotReplace(iX+nSuppX.*laggedChoices, (iRC-30).*2 + nSuppRC.*laggedChoices);
nll           = -sum(sum(log(p)));
   
    
end