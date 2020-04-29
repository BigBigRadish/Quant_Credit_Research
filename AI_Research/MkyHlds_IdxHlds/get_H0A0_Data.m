%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DATA FROM SQL DATABASE

combo = '68';
%idxname = 'H0A0';
date = '2013-04-30';
year = '2012';
quarter = '4';
exclusive = '1';
ultimate = '1';


H0A0Ana = get_H0A0_Holdings_Analytics(date,'0');
H0A0Ana.yrs_to_worst = NaN*ones(size(H0A0Ana,1),1);
H0A0Ana.dur_mod = NaN*ones(size(H0A0Ana,1),1);
H0A0Ana.cvx = NaN*ones(size(H0A0Ana,1),1);
H0A0Fin= get_H0A0_Holdings_CompanyIds_Metrics(date,'0',year,quarter,exclusive,ultimate);
H0A0Fin = join(H0A0Fin,H0A0Ana,'Keys',{'cusip','isin'},'RightVars',[8,9],'MergeKeys',true);
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

% get aggregate analytics for the Idx at the ticker and level 3 and level4
% industry sectors
[lvl3IdxAnaAggF,lvl3IdxAnaAggP] = IdxAnaAgg(H0A0Ana,8);
[lvl4IdxAnaAggF,lvl4IdxAnaAggP]  = IdxAnaAgg(H0A0Ana,9);
[tkrIdxAnaAggF,tkrIdxAnaAggP] = IdxAnaAgg(H0A0Ana,5);


% get aggregate financial info for the Idx at the ticker and level 3 and
% level 4 industry sectors
tkrIdxFinAgg = IdxFinAgg(H0A0Fin,3);
lvl3IdxFinAgg = IdxFinAgg(H0A0Fin,4);
lvl4IdxFinAgg = IdxFinAgg(H0A0Fin,5);
% 
% 
 