function [edge_struct,bins_metVarname,bin_num] = ...
                    get_edge_mat(H0A0,metrics,...
                                  edge_vec,edge_type_vec,...
                                  edge_equal_mass_weights)
    % size of edge_vec and metrics

    if ~isempty(edge_type_vec)
        if size(metrics,2)~=size(edge_type_vec,2)
                msg = ['size of edge_vec and metrics should be equal ' ...
                    'when edge_vec is not empty'];
                error('MATLAB:SortCompare', msg);    
        end
    end
    
    metnumVar = size(metrics,2);
    bins_metVarname = cell(1,metnumVar);
    edge_struct = struct([]);
    bin_num = zeros(1,metnumVar);
    
    if ~isempty(H0A0)
        [mkt_weight_col] = get_dsColNum(H0A0.Properties.VarNames,{'mkt_weight'});
        [met_vec] = get_dsColNum(H0A0.Properties.VarNames,metrics);
    end
    
    
    for i = 1:metnumVar
        bins_metVarname{i} = strcat('bins_',metrics{i});

        if (~isempty(edge_vec) && ~isempty(edge_type_vec))
           edge_struct(i).edge = edge_vec(edge_type_vec(i)).edge;
           
        elseif ~isempty(edge_equal_mass_weights) && ~isempty(H0A0)
           idx_not_missing = ~ismissing(H0A0(:,met_vec(i)));
           edge_struct(i).edge = ...
                equal_mass_edges(H0A0(idx_not_missing,...
                                    [mkt_weight_col met_vec(i)]),1,2,...
                                    edge_equal_mass_weights);
        end
        
        bin_num(i) = size(edge_struct(i).edge,2)-1;
        
    end
    

end
    
    
    
    