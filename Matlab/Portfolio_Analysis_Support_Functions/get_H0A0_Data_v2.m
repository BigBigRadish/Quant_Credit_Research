
function [ H0A0Fin, H0A0Ana ] = get_H0A0_Data_v2(year,quarter,date,faceValMin,exclusive,ultimate)
% GET H0A0 constituent analytics and financial data.
% Financial data has no lookahead bias in case financials have been
% restated.
%
% NOTE:
%   The analytics dataset includes a columnt with a flag that
%   indicates if financials are available for a particular
%   constituent.
%
% Inputs:
% 1. 'date': string date in format 'yyyy-mm-dd'.
%    The date has to be a month end.
% 2. 'faceValMin': filters constituent bonds with a face value
%   lower than variable. Set to '0' if you want ALL constituents.
% 3. 'year': calendar year to get financials from.
% 4. 'quarter': calendar quarter to get financials from.
% 5. 'exclusive': If set to 1, get metrics exclusively from the company
%   specified by @ultimate flag. If set to 0, then get metrics from the
%   alternate related company if the desired company (as specified by
%   @ultimate flag) has no related metrics.
% 6. 'ultimate' If set to 1, get metrics from the ultimate parent.
%   If set to 0, get metrics from the immediate related company.


% combo = '68';
%  faceValMin = '0';
%  date = '2012-12-31';
% year = '2012';
% quarter = '3';
% exclusive = '1';
% ultimate = '1';


H0A0Ana = get_H0A0_Holdings_Analytics_v2(date,faceValMin);
H0A0Ana.yrs_tw = NaN*ones(size(H0A0Ana,1),1);
%H0A0Ana.ur_mod = NaN*ones(size(H0A0Ana,1),1);
%H0A0Ana.cvx = NaN*ones(size(H0A0Ana,1),1);
H0A0Fin= get_H0A0_Holdings_CompanyIds_Metrics_v2(date,faceValMin,year,quarter,exclusive,ultimate);

H0A0Fin = join(H0A0Fin,H0A0Ana,'Keys',{'cusip','isin'},'RightVars',[9,10], ...
               'MergeKeys',true,'Type','inner');
if_col = size(H0A0Fin,2);
H0A0Fin = H0A0Fin(:,[1:3,if_col-1,if_col,4:if_col-2]);
H0A0Ana = join(H0A0Ana,H0A0Fin,'Keys',{'cusip','isin'},'RightVars',13,'MergeKeys',true);

% IdxInfo = join(IdxAna,IdxFin,'Keys',{'Cusip9','ISIN'},...
% 'LeftVars',[5,9:11,16:26],'RightVar',[11:24],'MergeKeys',true);
% 
% %  d3 = get_MkyCombo_CorpHoldings_Analytics(combo, date, idxname);
% %  d4 = get_MkyCombo_CorpHoldings_CompanyIds_Metrics(combo,date,year,quarter,exclusive,ultimate);
% 
% 
% % convert char columns in datasets to nominal type
% % dates are converted to numbers
strtonom;
% 

% % get aggregate analytics for the Idx at the ticker and level 3 and level4
% % industry sectors
% [lvl3H0A0AnaAggF,lvl3H0A0AnaAggP] = IdxAnaAgg(H0A0Ana(:,[8,16,6:7,15,17:30,32:end]));
% [lvl4H0A0AnaAggF,lvl4H0A0AnaAggP]  = IdxAnaAgg(H0A0Ana(:,[9,16,6:7,15,17:30,32:end]));
% [tkrH0A0AnaAggF,tkrH0A0AnaAggP] = IdxAnaAgg(H0A0Ana(:,[5,16,6:7,15,17:30,32:end]));
% 
% 
% % get aggregate financial info for the Idx at the ticker and level 3 and
% % level 4 industry sectors
% lvl3H0A0FinAgg = IdxFinAgg(H0A0Fin,4);
% lvl4H0A0FinAgg = IdxFinAgg(H0A0Fin,5);
% tkrH0A0FinAgg = IdxFinAgg(H0A0Fin,3); 
% 

 