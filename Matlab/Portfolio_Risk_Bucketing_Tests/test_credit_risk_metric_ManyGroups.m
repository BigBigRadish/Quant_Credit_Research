% [out_stats] = get_finDataStats(All_H0A0Fin_combined);
clear

load('test_calc_risk_metric.mat');
b.lvl_3(2) = 'Utility';
a.lvl_3(2) = 'Utility';
% [risk_metric, idx_issuers] = ...
%     calc_risk_metric(Fin,Ana,[]);

[risk_metric, idx_issuers] = ...
    calc_risk_rank(Fin,Ana,{'lvl_3'});
% 
% [risk_metric, idx_issuers] = ...
%     calc_risk_metric(b,a,[]);

% [risk_metric, idx_issuers] = ...
%     calc_risk_metric(b,a,{'lvl_3'});

