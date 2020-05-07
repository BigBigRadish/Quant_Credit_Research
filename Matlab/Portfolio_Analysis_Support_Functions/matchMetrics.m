function [f_vec] = matchMetrics(OrigPortConstituentBins,idx_include,...
                            categoriesOrder,categoriesNoOrder,metrics,control, ...
                            OrigPort_bin_weights,FiltPort_bin_weights,binNames)
    
	catnumOrder = size(categoriesOrder,2);
    catnumNoOrder = size(categoriesNoOrder,2);
    metnumVar = size(metrics,2);                        

    % get column numbers for categories & metrics in the bin weights
    % datasets
    [cat_vecU] = get_dsColNum(OrigPort_bin_weights.Properties.VarNames,categoriesOrder);
    [met_vecU] = get_dsColNum(OrigPort_bin_weights.Properties.VarNames,binNames);
    [cat_vecNO] = get_dsColNum(OrigPort_bin_weights.Properties.VarNames,categoriesNoOrder);
    
    %% Calculate distance between numeric bins
    % use euclidean distance as a measure of how far is one bin from
    % another in each of the dimensions

    unique_bins = double(OrigPort_bin_weights(:,met_vecU));
    num_cuadrants = size(unique_bins,1);
    
    % create a 3-D matrix to store the one dimensional distance of every
    % bin to each other in each of the numeric dimensions
    % each c1d(:,:,i) will store the bin distances in the ith metric
    c1d = zeros(num_cuadrants,num_cuadrants,metnumVar);

    for i = 1:metnumVar
        c1 = unique_bins(:,i);
        c1v = c1*ones(1,size(c1,1));
        c1h = ones(size(c1,1),1)*c1';
        c1d(:,:,i) = (c1h-c1v).^2;
    end

    dist_mat = sqrt(sum(c1d,3));
    
    
    % find those bins for which the filtered portfolio has no elements, and
    % hence zero weight assigned to it.
    % the distance of every included bin to the bins not being represented
    % by the constructed portfolio is Inf
    zero_weight_idx = find(FiltPort_bin_weights.GroupCount==0);
    dist_mat(zero_weight_idx,:) = inf;

    
    % add 2 columns to ubs matrix. as of this point the unique_bins matrix has
    % num_var +2 columns corresponding to the H0A0 bin weight and the filtered
    % portfolio bin weight
    unique_bins = horzcat(unique_bins,[OrigPort_bin_weights.mkt_weight FiltPort_bin_weights.mkt_weight]);

    % add 5 columns to the unique_bins matrix.
    unique_bins(:,end+1:end+5)=0;
    % H0A0 weight is in the column right of the last bin column
    weights_missing_bins = OrigPort_bin_weights.mkt_weight(zero_weight_idx);

    % w = unique_bins(zw,metnumVar+1);
    % find those elements in the distance matrix less than a desired
    % threshold. the column number corresponds to the bin number, and each
    % row number corresponds to those bins which are within the threshold
    % distance of the bin indicated by the column.
    closest_bins_idx = dist_mat<(sqrt(metnumVar)+0.1);

    % for each of the bins not included in the filtered portfolio,
    % distribute its index weight amidst the closest bins included in the
    % filtered portfolio.
    
    for i=1:size(zero_weight_idx)
        % check there are bins that are within limit distance, and check
        % that none of the bins indicate and out of bounds element. When
        % defining the edges, the histc function will assign a zero bin
        % number to elements that do not fall within any of the bins, like
        % NaN values. In those cases, we are choosing to not distribute
        % that bins weight among other bins.
       
        % get idx of bins which are within required metric distance
        % from bin which has no securities representing it in the resulting
        % portfolio (the bins within metric distance do not necessarily
        % share the same category classification)
        idx_met=zeros(num_cuadrants,1);
        if sum(closest_bins_idx(:,zero_weight_idx(i)))~=0 && (sum(unique_bins(i,1:metnumVar)==0)==0)
            idx_met = closest_bins_idx(:,zero_weight_idx(i));
        end
        
        
        % ORDERED CATEGORIES
        % get idx of bins which share the same category classification as
        % the target bin (bin whicn has no securities representing it in 
        % the resulting portfolio). These bins may not necessarily be
        % within metric distance from the target bin.
        ixCo = zeros(num_cuadrants,catnumOrder);
        for k=1:catnumOrder
            ixCo(:,k) = ...
                eval(strcat('OrigPort_bin_weights{zero_weight_idx(i,1),cat_vecU(k)}==OrigPort_bin_weights.',categoriesOrder{k}));     
        end
        
        % NO ORDER CATEGORIES
        ixCn = zeros(num_cuadrants,catnumNoOrder);
        for k=1:catnumNoOrder
            ixCn(:,k) = ...
                eval(strcat('OrigPort_bin_weights{zero_weight_idx(i,1),cat_vecNO(k)}==OrigPort_bin_weights.',categoriesNoOrder{k}));     
        end
        
        % Most specific categories and metrics
        idx_exist = 0;
        j=catnumOrder;
        most_spec_catmet = zeros(num_cuadrants,1);
        % Work backwards from most specific ordered category to least
        % specific.
        while (idx_exist == 0) && (j>0)
            ixC_yesOrder = ixCo(:,j);
            % if there is overlap between ordered categories and the index
            % of bins within metric distance, then check for further
            % overlap with 'non-ordered categories' by checking for
            % overlap with the most non-ordered categories possible. Given
            % catnumNoOrder number of non-ordered categories, work
            % backwards by checking for overlap with all categories, and if
            % no overlap is found, then with catnumNoOrder-1 categories,
            % and so on, stopping if overlap is found, or if no overlap is
            % found. If no overall overlap is found, restart the loop by
            % starting the check with the next most specific ordered
            % category set.
            if sum(ixC_yesOrder .* idx_met)~=0
                k=1;
                while (k<=catnumNoOrder)
                    ixC_noOrder = sum(ixCn,2)==(catnumNoOrder-k+1);
                    if sum(ixC_yesOrder .* ixC_noOrder .* idx_met)~=0
                        most_spec_catmet = ixC_yesOrder .* ixC_noOrder .* idx_met;
                        idx_exist=1;
                        break
                    end
                    k=k+1;
                end
            end
            if idx_exist==1
                break
            end
            j=j-1;
        end      
        
        % Most specific categories only
        % Similar to 'most-specific categories and metrics' but not
        % checking for overlap with the index of bins within metric
        % distance
        idx_exist = 0;
        j=catnumOrder;
        most_spec_cat = zeros(num_cuadrants,1);
        while (idx_exist == 0) && (j>0)
            ixC_yesOrder = ixCo(:,j);
            k=1;
            while (k<=catnumNoOrder)
                ixC_noOrder = sum(ixCn,2)==(catnumNoOrder-k+1);
                if sum(ixC_yesOrder .* ixC_noOrder)~=0
                    most_spec_cat = ixC_yesOrder .* ixC_noOrder;
                    idx_exist=1;
                    break
                end
                k=k+1;
            end
            if idx_exist==1
                break
            end            
            j=j-1;
        end
        
        
        % Match only metrics
        if strcmp(control,'metrics_only')
            aux_idx = idx_met;
        end
        % Match only categories
        if strcmp(control,'categories_only')
            aux_idx = most_spec_cat;
        end
        % Match both metrics and categories
        if strcmp(control,'cat_met_both')
            aux_idx = most_spec_catmet;
        end
        % Match either metrics or categories
        if strcmp(control,'cat_met_either')
            aux_idx = most_spec_cat | idx_met;
        end
            
        if (sum(aux_idx)~=0)
           % divides the weight of the bin not present in the filtered
           % portfolio amidst those bins in the portfolio which are within
           % the threshold distance defined earlier.
           unique_bins(:,metnumVar+3) = unique_bins(:,metnumVar+3)+ weights_missing_bins(i)/sum(aux_idx)*aux_idx;
           % accumulates number of times that a particular bin has
           % increased its weight in the loop
           unique_bins(:,metnumVar+4) = unique_bins(:,metnumVar+4)+aux_idx;
        end
    end

    % the weight of each included bin will be the weight of the
    % corresponding in the original portfolio + the total weight that was
    % distributed to it and that is stored in unique_bins(:,metnumVar+3)
    f1 = unique_bins(:,metnumVar+2)~=0;
    unique_bins(:,metnumVar+5) = unique_bins(:,metnumVar+1).*f1 + unique_bins(:,metnumVar+3);
    % the total weight of the constructed portfolio might still not add up
    % to 100% as the weight of some bins not included in the constructed
    % portfolio might not have been distributed among included bins (there
    % were no bins in the include portfolio which were within the maximum
    % metric distance or in the same combination of categories or both).
    factor = sum(unique_bins(:,metnumVar+1))/sum(unique_bins(:,metnumVar+5));
    unique_bins(:,metnumVar+6) = factor.*unique_bins(:,metnumVar+5);


    % determine the factor by which the original portfolio weights of the
    % securities belonging to a particular bin should be multiplied so as
    % to obtain the weight determined for the constructed portfolio in the
    % previous step.
    f1 = unique_bins(:,metnumVar+6)./unique_bins(:,metnumVar+2);
    f1(f1==inf,1)=0;
    f1(isnan(f1),1)=0;
    [met_vecOrig] = get_dsColNum(OrigPortConstituentBins.Properties.VarNames,binNames);
    num_rows = size(OrigPortConstituentBins,1);    
    aux_vec = zeros(size(OrigPortConstituentBins,1),1);
    for i = 1:num_cuadrants

        if f1(i)~=0
            ix = ones(num_rows,1)*double(OrigPort_bin_weights(i,met_vecU));
            ix = ix==double(OrigPortConstituentBins(:,met_vecOrig));
            ix = sum(ix,2);
            ix = ix==metnumVar;

            ixC = ones(num_rows,1);
            for j=1:catnumNoOrder
                auxstr = 'OrigPort_bin_weights{i,cat_vecNO(j)}==OrigPortConstituentBins.';
                ixC = ixC & eval(strcat(auxstr,categoriesNoOrder{j}));     
            end            

            for j=1:catnumOrder
                auxstr = 'OrigPort_bin_weights{i,cat_vecU(j)}==OrigPortConstituentBins.';
                ixC = ixC & eval(strcat(auxstr,categoriesOrder{j}));
            end
            ix = ix & ixC;
            b = sum(ix);
            
            aux_vec = aux_vec + f1(i)*ix;
        end
        
    end
    
    aux_vec(~idx_include) = 0;
    f_vec = aux_vec;
    f_vec = mat2dataset(f_vec);
    f_vec.Properties.VarNames(end)={'mult'};

end
