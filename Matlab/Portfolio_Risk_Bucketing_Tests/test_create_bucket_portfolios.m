clc
clear

load('test_create_bucket_portfolios.mat')

% [buckets] = create_bucket_portfolios(...
%         num_buckets,H0A0Ana(idx_issuers,vec),risk_metric(idx_issuers,1),grouping_var);

[buckets] = create_bucket_portfolios_simple(...
        num_buckets,H0A0Fin,risk_metric,...
        idx_issuers,grouping_var);

% [buckets] = create_bucket_portfolios_simple(...
%         num_buckets,H(4:5,vec),R(4:5,1),grouping_var);


