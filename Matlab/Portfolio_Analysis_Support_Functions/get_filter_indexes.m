function [filter] = get_filter_indexes(minsize,H0A0Ana, H0A0Fin)
%get_filter_indexes logical vector of securities to include in portfolio


% exclude by face value size
idx_exclude_size = H0A0Ana.face_val < minsize;

% exclude by political risk, industry, and lower/higher price quartile for
% each level 3 subsector
idx_exclude_sec = filter_exclude_security(H0A0Ana);

% exclude securities based on issuer financials
[idx_exclude_issuer, idx_issuers]= ...
        filter_exclude_issuers(H0A0Fin,H0A0Ana);

idx_exclude = idx_exclude_size | idx_exclude_sec | idx_exclude_issuer;

% Create logical vector to include back financials
idx_fin_include = ...
        (H0A0Ana.lvl_3 == 'Financial Services' | ...
        H0A0Ana.lvl_3 == 'Banking' | ...
        H0A0Ana.lvl_3 == 'Insurance');

% Determine securities to include
idx_include = (idx_fin_include & ~idx_exclude_size) | ~idx_exclude;

% Store filters in dataset
filter = [idx_include ...
              idx_exclude_size idx_exclude_sec ...
              idx_exclude_issuer idx_issuers ...
              idx_fin_include];
filter = mat2dataset(filter);
filter.Properties.VarNames = {'include','x_size','x_sec','x_issuer',...
                              'inc_issuer','fin_inc'};

end



