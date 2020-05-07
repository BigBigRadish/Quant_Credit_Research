function [bin_weights] = get_BinWeights(H0A0,sec_bins,categories,binNames)
    
    H0A0 = horzcat(H0A0,sec_bins);

    [cat_vecH] = get_dsColNum(H0A0.Properties.VarNames,categories);
    [bin_vecH] = get_dsColNum(H0A0.Properties.VarNames,binNames);
    
    [mkt_weight_col] = get_dsColNum(H0A0.Properties.VarNames,{'mkt_weight'});
    [cusip_col] = get_dsColNum(H0A0.Properties.VarNames,{'cusip'});
    
	catnumVar = size(categories,2);
    metnumVar = size(binNames,2);
    
    bin_weights = unique(H0A0(:,[cat_vecH bin_vecH]));
    [cat_vecU] = get_dsColNum(bin_weights.Properties.VarNames,categories);
    [bin_vecU] = get_dsColNum(bin_weights.Properties.VarNames,binNames);
    
    r = size(bin_weights,1);
    cuadrant_weights = zeros(r,2);
    num_rows = size(H0A0,1);
    idx_include = H0A0.mkt_weight~=0;

    for i = 1:r
        
        ix = ones(num_rows,1)*double(bin_weights(i,bin_vecU));
        ix = ix==double(H0A0(:,bin_vecH));
        ix = sum(ix,2);
        ix = ix==metnumVar;

        
        ixC = ones(num_rows,1);
        for j=1:catnumVar
            auxstr = 'bin_weights{i,cat_vecU(j)}==H0A0.';
            ixC = ixC & eval(strcat(auxstr,categories{j}));     
        end
        ix = ix & ixC & idx_include;
        
       cuadrant_weights(i,1)= sum(ix);
       cuadrant_weights(i,2)= sum(double(H0A0(ix,mkt_weight_col)));
       
    end

    bin_weights = horzcat(bin_weights,mat2dataset(cuadrant_weights));
    bin_weights.Properties.VarNames(end-2+1:end) = ...
                                    {'secNum',...
                                    'weight'};




end
            