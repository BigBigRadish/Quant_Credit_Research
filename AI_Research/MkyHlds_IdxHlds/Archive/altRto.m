
%% Alternate leverage and interest coverage metric to use with percentile statistic


IdxFin.PctLev = 0;
IdxFin.PctIntCov = 0;
t = IdxFin;

% Alternate Leverage measure

absMaxLev = max(abs(t.TotalLeverage));
absMinLev = min(abs(t.TotalLeverage));
maxTotLev = max(t.TotalLeverage);
minTotLev = min(t.TotalLeverage(t.TotalLeverage>0));

% worse off companies than those with +ve Total Debt and +ve EBITDA
idx = t.EBITDA==0 & t.TotalDebt>0 & t.TotalLeverage <0;
t.PctLev(idx) = maxTotLev + (1./(absMaxLev*t.TotalAssets(idx).*t.TotalRevenue(idx)));


idx = t.EBITDA<0 & t.TotalDebt>0;
t.PctLev(idx) = maxTotLev + (1./(abs(t.TotalLeverage(idx)).*t.TotalAssets(idx).*t.TotalRevenue(idx)));


% companies with +ve Total Debt and +ve EBITDA
idx = t.EBITDA>0 & t.TotalDebt>0 & t.TotalLeverage>0;
t.PctLev(idx) = t.TotalLeverage(idx);

% better off companies than those with +ve Total Debt and +ve EBITDA 
idx = t.EBITDA==0 & t.TotalDebt<0 & t.TotalLeverage <0;
t.PctLev(idx) = minTotLev - (1./(absMinLev*t.TotalAssets(idx).*t.TotalRevenue(idx)));

idx = t.EBITDA<0 & t.TotalDebt==0;

idx = t.EBITDA<0 & t.TotalDebt<0 & t.TotalLeverage <0;
t.PctLev(idx) = minTotLev - (1./(abs(t.TotalLeverage(idx)).*t.TotalAssets(idx).*t.TotalRevenue(idx)));


minTotLev = min(t.PctLev(t.PctLev>0));


% better off companies than those with -ve Total Debt and -ve EBITDA

idx = t.EBITDA>0 & t.TotalDebt<0 & t.TotalLeverage <0;
t.PctLev(idx) = minTotLev - (1./(abs(t.TotalLeverage(idx)).*t.TotalAssets(idx).*t.TotalRevenue(idx)));


IdxFin.PctLev = t.PctLev;


% Alternate Interest Coverage measure

IdxFin.PctIntCov = 0;
maxIntCov = max(t.InterestCoverage);
minIntCov = min(t.IntCoverage(t.IntCoverage>0));

idx = t.EBITDA<0 & t.IntCov


