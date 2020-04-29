%% Alternate leverage and interest coverage metric to use with percentile statistic
% Stack on EBITDA dimension
% Lower number is better

IdxFin.PctLev = 0;
IdxFin.PctIntCov = 0;
t = IdxFin;

% Companies with +ve EBITDA
idx = t.EBITDA>0 & ~isnan(t.reportingTemplateTypeId);
t.PctLev(idx) = t.TotalDebt(idx)./t.EBITDA(idx);

aux_max = max(t.PctLev(idx));

% Companies with 0 EBITDA
idx = t.EBITDA ==0 & ~isnan(t.reportingTemplateTypeId);
cur_min = min(t.TotalDebt(idx));
t.PctLev(idx) = aux_max - cur_min + t.TotalDebt(idx);

aux_max = max([max(t.PctLev(idx)) , aux_max]);

% Companies with -ve EBITDA
idx = t.EBITDA < 0 & ~isnan(t.reportingTemplateTypeId);
cur_min = min(t.TotalDebt(idx)./t.EBITDA(idx));
t.PctLev(idx) =  aux_max - cur_min + t.TotalDebt(idx)./t.EBITDA(idx);
