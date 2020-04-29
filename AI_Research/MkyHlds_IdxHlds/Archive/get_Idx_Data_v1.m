%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET DATA FROM SQL DATABASE
%
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
IdxFin = IdxFin(:,[1:3,20,21,4:19]);
IdxAna = join(IdxAna,IdxFin,'Keys',{'Cusip9','ISIN'},'RightVars',13,'MergeKeys',true);

IdxInfo = join(IdxAna,IdxFin,'Keys',{'Cusip9','ISIN'},...
'LeftVars',[5,9:11,16:26],'RightVar',[11:19],'MergeKeys',true);

%  d3 = get_MkyCombo_CorpHoldings_Analytics(combo, date, idxname);
%  d4 = get_MkyCombo_CorpHoldings_CompanyIds_Metrics(combo,date,year,quarter,exclusive,ultimate);


% convert char columns in datasets to nominal type
% dates are converted to numbers
strtonom;

% get aggregate analytics for the Idx at the ticker and level 3 and level4
% industry sectors
lvl3IdxAgg = IdxAnaAgg(IdxAna,8);
lvl4IdxAgg = IdxAnaAgg(IdxAna,9);
tkrIdxAgg = IdxAnaAgg(IdxAna,5);


% get aggregate financial info for the Idx at the ticker and level 3 and
% level 4 industry sectors
tkrFinAgg = IdxFinAgg(IdxFin,3);
lvl3FinAgg = IdxFinAgg(IdxFin,4);
lvl4FinAgg = IdxFinAgg(IdxFin,5);


 
 