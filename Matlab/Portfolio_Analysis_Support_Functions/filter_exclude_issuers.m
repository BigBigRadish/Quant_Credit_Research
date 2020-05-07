function [idx_exclude, idx_issuers] = ...
    filter_exclude_issuers(auxFinDS,auxAnaDS)
%% Return indexing vector of issuers to exclude based on financials.

% Turn off warning
warning('off','stats:dataset:subsasgn:DefaultValuesAddedVariable');


% Sort inputs to have the rows of the two datasets correspond
% to each other. 
[auxAnaDS, auxFinDS]=...
        sortCompare(auxAnaDS,auxFinDS,...
        [2,4],[1,2]);


auxAnaDS = horzcat(auxAnaDS, auxFinDS(:,8));

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

% Exclude those records with EBITDA<0 or InterestExpense>0
% Remove records for which EBITDA<=0, or Interest Expense>=0
% An expense is recorded in the database as a -ve quantity.
% Exclude records for which reporting Template Type Id is different from:
% Standard=1, Utilities=4, Real Estate=5, General=14, REIT=19. Basically 
% exclude whose reporting template corresponds to financial services,
% or insurance.
% auxFinDS = auxFinDS(auxFinDS.EBITDA>0 & auxFinDS.InterestExpense<0,:);
aux_utcFin = idx_uniqueTkrCID & ~noData & ...
            auxFinDS.EBITDA>0 & auxFinDS.InterestExpense<0 & ...
            (auxFinDS.reportingTemplateTypeId == 1 | ...
            auxFinDS.reportingTemplateTypeId == 4 | ...
            auxFinDS.reportingTemplateTypeId == 5 | ...
            auxFinDS.reportingTemplateTypeId == 14 | ...
            auxFinDS.reportingTemplateTypeId == 19);
        
% Only rank issuer financials if the number of companies with usable
% financials is greater than 25% of the number of distinct companies
% Otherwise do not exclude any securities based on issuer financials.
if sum(aux_utcFin)> 10
    
    %% Determine financial metrics highly correlated to analytics
    AnaAggFin = horzcat(auxAnaDS,auxFinDS(:,22:77));

    % Determine financial metrics highly correlated to analytics
    % Filter 'AnaAggFin' dataset using             
    X = AnaAggFin(aux_utcFin,[7:8,16,18:39,41:44]);
    X = double(X);
    Y = AnaAggFin(aux_utcFin,47:102);
    Y = double(Y);
    Y(isnan(Y)) = 0;


    [RHO,PVAL] = corr(X,Y);
    RHOds = mat2dataset(RHO);
    RHOds.Properties.VarNames = AnaAggFin.Properties.VarNames(47:102);
    RHOds.Properties.ObsNames = AnaAggFin.Properties.VarNames([7:8,16,18:39,41:44]);

    PVALds = mat2dataset(PVAL);
    PVALds.Properties.VarNames = AnaAggFin.Properties.VarNames(47:102);
    PVALds.Properties.ObsNames = AnaAggFin.Properties.VarNames([7:8,16,18:39,41:44]);


    %% Rank issuers based on financial metrics
    metrics_vec = [1 3 6 21 38]; % Net Debt, TotAssets, IntCov, TotLev, SrDbtPct
    % metrics_vec1 = [44 52 67];
    % metrics_vec5 = [28 34 44 52 67];

    % NaN's appear at the bottom of the sort.
    aux_AAFin = double(AnaAggFin(aux_utcFin,47:102));
    %aux_AAFin(isnan(aux_AAFin))=0;
    [~, sort_idx] = sort(aux_AAFin);
    [r, c] = size(sort_idx);
    num = zeros(r,c);
    for i = 1:c
        num(sort_idx(:,i),i) = 1:r;
    end    
    nan_idx = isnan(aux_AAFin);
    num_nans = sum(nan_idx);

    num_sign = sign(RHO(19,:)); % RHO row 19 corresponds to OAS
    % sign of correlation is currently being forced to a particular value.
    num_sign(:,metrics_vec) = [1,-1,-1,1,1];
    num_sign(isnan(num_sign))=0;
    num_nans = ones(r,1)*num_nans;
    num = num+num_nans;
    num(nan_idx) = 1;

    aux = zeros(1,56);
    aux(1,metrics_vec) = num_sign(1,metrics_vec);
    risk_metric = num*aux';

    [~, sort_rsk] = sort(risk_metric);

    % find indices of securities in the 1 and 4 quartile
    idx = sort_rsk<0.25*r | sort_rsk>0.75*r;

    % identify records which have the ticker and company ids to exclude
    filt_iss = AnaAggFin(aux_utcFin,[6,46]);
    filt_iss = filt_iss(idx,:);
    
    idx_exclude = zeros(size(auxAnaDS,1),1);
    for ix=1:size(filt_iss,1)
       idx_exclude = idx_exclude | (auxAnaDS.tkr == filt_iss.tkr(ix) & ...
                     auxAnaDS.companyId==filt_iss.companyId(ix));
    end

    idx_issuers = aux_utcFin;
else                
    idx_exclude = zeros(r,1);
    idx_issuers = aux_utcFin;    
end

% Turn on warning
warning('on','stats:dataset:subsasgn:DefaultValuesAddedVariable');






                
                