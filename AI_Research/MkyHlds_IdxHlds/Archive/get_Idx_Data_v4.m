%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DATA FROM SQL DATABASE

combo = '68';
idxname = 'H0A0';
date = '2013-04-30';
year = '2012';
quarter = '4';
exclusive = '1';
ultimate = '1';

IdxAna = get_Idx_Holdings_Analytics(idxname,date,'0');
IdxFin= get_Idx_Holdings_CompanyIds_Metrics(idxname,date,'0',year,quarter,exclusive,ultimate);
IdxFin = join(IdxFin,IdxAna,'Keys',{'Cusip9','ISIN'},'RightVars',[8,9],'MergeKeys',true);
if_col = size(IdxFin,2);
IdxFin = IdxFin(:,[1:3,if_col-1,if_col,4:if_col-2]);
IdxAna = join(IdxAna,IdxFin,'Keys',{'Cusip9','ISIN'},'RightVars',13,'MergeKeys',true);

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
[lvl3IdxAnaAggF,lvl3IdxAnaAggP] = IdxAnaAgg(IdxAna,8);
[lvl4IdxAnaAggF,lvl4IdxAnaAggP]  = IdxAnaAgg(IdxAna,9);
[tkrIdxAnaAggF,tkrIdxAnaAggP] = IdxAnaAgg(IdxAna,5);


% get aggregate financial info for the Idx at the ticker and level 3 and
% level 4 industry sectors
tkrIdxFinAgg = IdxFinAgg(IdxFin,3);
lvl3IdxFinAgg = IdxFinAgg(IdxFin,4);
lvl4IdxFinAgg = IdxFinAgg(IdxFin,5);
% 
% 
 