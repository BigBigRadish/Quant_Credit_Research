function [risk_metric, idx_issuers] = ...
    credit_risk_metric_ManyGroups(auxFinDS,auxAnaDS,grouping_var)
% Ranks issuers and assign this ranking to corresponding issues.
% Only ranks issuers for which all data exists, and for which EBITDA>0
% and Interest Expense < 0
% Issuers not included in rankings will have its corresponding issues
% assigned a rank of NaN.
% grouping_var should be empty or be a single cell string array with a name
% of a column that corresponds to a grouping category. When non-empty,
% issuers are ranked against peers in their corresponding group.
% risk_metric: contains issues assigned ranking
% idx_issuers: keeps track of issuers that were ranked.


% Turn off warning
warning('off','stats:dataset:subsasgn:DefaultValuesAddedVariable');


% Sort inputs to have the rows of the two datasets correspond
% to each other. 
[auxAnaDS, auxFinDS]=...
        sortCompare(auxAnaDS,auxFinDS,...
        [2,4],[1,2]);

cid_col = get_dsColNum(auxFinDS.Properties.VarNames,{'companyId'});
auxAnaDS = horzcat(auxAnaDS, auxFinDS(:,cid_col));

%% Clean Financial dataset table
% In particular we are replacing NaN's for all debt ammount
% metrics, EBITDA margin, and Net Rental Expense
col_vec = [31:32,41,44,50:77]; % colums in dataset that contain fields of interest
[auxFinDS] = cleanDs(auxFinDS,col_vec);

% Identify those records (rows) for which at least one metric is a NaN
noData = ismissing(auxFinDS);
noData = any(noData,2);

%% Identify unique issuers with financial metrics

% Identify all the unique combinations of ticker and company id,
% and create a indexing vector to extract only the rows with unique
% combinations.
[~,I] = unique(auxFinDS(:,[4,8]));
r = size(auxFinDS,1);
idx_uniqueTkrCID = zeros(r,1);
idx_uniqueTkrCID(I,:) = 1;
idx_uniqueTkrCID = ones(r,1) & idx_uniqueTkrCID;

% Only include records for which EBITDA>=0 or InterestExpense<=0
% An expense is recorded in the database as a -ve quantity.
% auxFinDS = auxFinDS(auxFinDS.EBITDA>0 & auxFinDS.InterestExpense<0,:);
% Include records for which reporting Template Type Id is:
% Standard=1, Utilities=4, Real Estate=5, General=14, REIT=19. Basically 
% exclude whose reporting template corresponds to financial services,
% or insurance.
% Exclude those records for which lvl_3 classification
aux_utcFin1 = idx_uniqueTkrCID & ~noData & ...
        auxFinDS.EBITDA>0 & auxFinDS.InterestExpense<0 &...
        (auxFinDS.reportingTemplateTypeId == 1 | ...    % standard
        auxFinDS.reportingTemplateTypeId == 4 | ...     % utilities
        auxFinDS.reportingTemplateTypeId == 5 | ...     % real estate
        auxFinDS.reportingTemplateTypeId == 14 | ...    % general
        auxFinDS.reportingTemplateTypeId == 19) & ...   % REIT
        ~(auxFinDS.lvl_3 == 'Financial Services' | ...
        auxFinDS.lvl_3 == 'Banking' | ...
        auxFinDS.lvl_3 == 'Insurance');        


num_groups = 1;
groupNameList = [];
if ~isempty(grouping_var) 
    grp_col = get_dsColNum(auxAnaDS.Properties.VarNames,grouping_var);
    groupNameList = unique(auxAnaDS(aux_utcFin1,grp_col));
    num_groups = size(groupNameList,1);
end
        
idx_issuers = zeros(size(auxAnaDS,1),1);
risk_metric = NaN * ones(size(auxAnaDS,1),1);


for i=1:num_groups

    grp_flt = ones(size(auxAnaDS,1),1);
    if ~isempty(grouping_var) 
        aux_str = ['auxAnaDS.' grouping_var{1},'==groupNameList.',grouping_var{1},'(i)'];
        grp_flt = eval(aux_str);
        % grp_flt = auxAnaDS.lvl_3==groupNameList.lvl_3(i);
    end
    
    % Only include records for which EBITDA>=0 or InterestExpense<=0
    % An expense is recorded in the database as a -ve quantity.
    % auxFinDS = auxFinDS(auxFinDS.EBITDA>0 & auxFinDS.InterestExpense<0,:);    
    aux_utcFin = aux_utcFin1 & grp_flt;
        
    % Only rank issuer financials if the number of companies with usable
    % financials is greater than 25% of the number of distinct companies
    % Otherwise do not exclude any securities based on issuer financials.
     if sum(aux_utcFin)> 0
        
        idx_issuers = idx_issuers | aux_utcFin;
        
        [risk_val] = credit_risk_metric_OneGroup(auxAnaDS(aux_utcFin,:),auxFinDS(aux_utcFin,:));

%         [~, sort_rsk] = sort(risk_val);
%         risk_val(sort_rsk,1)= (1:size(risk_val))';
        
        
        % assign calculated risk metric to securities in portfolio
        % assign the metric calculated for each ticker/companyId combination
        % to all securities sharing the same ticker/companyId
        col_vec = get_dsColNum(auxFinDS.Properties.VarNames,{'ticker','companyId'});
        filt_iss = auxFinDS(aux_utcFin,col_vec);
        
        for ix = 1:size(filt_iss,1)
            aux_idx = auxFinDS.ticker == filt_iss.ticker(ix) & auxFinDS.companyId == filt_iss.companyId(ix);
            risk_metric(aux_idx) = risk_val(ix);
        end

     end

end

% Turn on warning
warning('on','stats:dataset:subsasgn:DefaultValuesAddedVariable');






                
                