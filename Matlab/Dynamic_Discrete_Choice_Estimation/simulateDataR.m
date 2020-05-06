function [choices,iRC, iX] = simulateDataR(deltaU,capPi,tPeriods,nBuses)
% deltaU is supportRC x supportX

nSuppRC  = size(capPi,1);
nsuppX   = size(deltaU, 2);

oneMinPi = eye(nSuppRC)-capPi';
pInf     = [oneMinPi(1:nSuppRC-1,:);ones(1,nSuppRC)]\[zeros(nSuppRC-1,1);1];
%{
Then, it uses the auxiliary function |randomDiscrete| (see Appendix \ref{misc}) and the values stored in |pInf| to simulate a $1\times N$ vector of values of $X_1$ from the stationary distribution $P^\infty$ and stores their indices in |iX|.
%}
% Initialize RC from stationary db
iRC      = zeros(nBuses, 1);
iRC      = randomDiscrete(pInf*ones(1,nBuses));
% Initialize x from x = 1
iX       = ones(1, nBuses);
%{
Using these $N$ simulated values of $X_1$, and $N$ simulated values of $-\Delta\varepsilon_1\equiv\varepsilon_1(0)-\varepsilon_1(1)$ that are stored in |deltaEpsilon|, it simulates $N$ values of the first choice by using that $A_1=1$ if $\Delta U(X_1,0)>-\Delta\varepsilon_1$ and $A_1=0$ otherwise. These are stored in the $1\times N$ vector |choices|.
%}		
deltaEpsilon = random('ev',zeros(1,nBuses),ones(1,nBuses))-random('ev',zeros(1,nBuses),ones(1,nBuses));
choices      = deltaU(iRC, iX)' > deltaEpsilon;
%{
	Finally, $N$ values of $X_t$ are simulated, using the transition matrix $\Pi$ and |randomDiscrete|, and their indices added as a row to the bottom of the $(t-1)\times N$ matrix |iX|; and $N$ values of $A_t$ are simulated, using that  $A_t=1$ if $\Delta U(X_t,A_{t-1})>-\Delta\varepsilon_t$ and $A_t=0$ otherwise, and stored as a row at the bottom of the $(t-1)\times N$ matrix |choices|; recursively for $t=2,\ldots,T$.
%}
for t = 2:tPeriods
    for j = 1: nBuses
   	iRC           = [iRC;randomDiscrete(capPi(iRC(end,:),:)')];
	deltaEpsilon  = random('ev',zeros(1,nBuses),ones(1,nBuses))-random('ev',zeros(1,nBuses),ones(1,nBuses));
	choices(t, :) = deltaU(iRC, iX) > deltaEpsilon;
    if choices(t, j) == 1
    iX(j) = 1;
    else
        iX(j) = min(7, iX + 1);
    end
    end
end

end