function [H0AO_sec_bins] = ...
            get_BinValues(H0A0,categories,metrics,edge_struct,binNames)

num_var = size(metrics,2);

[mkt_weight_col] = get_dsColNum(H0A0.Properties.VarNames,{'mkt_weight'});
[cusip_col] = get_dsColNum(H0A0.Properties.VarNames,{'cusip'});
[met_vec] = get_dsColNum(H0A0.Properties.VarNames,metrics);
[cat_vec] = get_dsColNum(H0A0.Properties.VarNames,categories);

bins_mat = zeros(size(H0A0,1),num_var);
for i =1:num_var
   [~, bins_mat(:,i)] = histc(double(H0A0(:,met_vec(i))),...
                                edge_struct(i).edge);
end

H0AO_sec_bins = horzcat(H0A0(:,[cusip_col mkt_weight_col cat_vec]),...
                mat2dataset(bins_mat));            
H0AO_sec_bins.Properties.VarNames(end-num_var+1:end) = binNames;
