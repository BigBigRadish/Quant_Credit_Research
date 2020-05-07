function [mult_vec] = mod_port(H0A0_sec_binsMod,instruct)

    num_inst = size(instruct,1);
    num_rows = size(H0A0_sec_binsMod,1);
    orig_weights = H0A0_sec_binsMod.mkt_weight;
    new_weights = zeros(num_rows,1);
    ixM = zeros(num_rows,num_inst);
    w0 = zeros(num_inst,1);
    w_add = zeros(num_inst,1);
    
    
    for i=1:num_inst

        binNames = strcat('bins_',instruct{i,1});
        metnumVar = size(instruct{i,1},2);
        [met_vecU] = get_dsColNum(H0A0_sec_binsMod.Properties.VarNames,binNames);
        
        ix = ones(num_rows,1)*double(instruct{i,2});
        ix = ix==double(H0A0_sec_binsMod(:,met_vecU));
        ix = sum(ix,2);
        ix = ix==metnumVar;
        
        ixM(:,i)=ix;
        w0(i) = sum(orig_weights(ix,1));
        if ischar(instruct{i,3})
            aux = str2num(strrep(instruct{i,3},'%',''));
            w_add(i) = w0(i)*aux/100;
        elseif isnumeric(instruct{i,3})
            w_add(i) = instruct{i,3};
        end
        %w_add(i) = instruct{i,3};
        if w0(i)+w_add(i)<0
           new_weights(ix) = 0;
        else
            new_weights(ix) = ...
                orig_weights(ix)*(w0(i)+w_add(i))/w0(i);
        end
        
    end
    
    jx = ~any(ixM,2);
    sum_wix = sum(new_weights(~jx));
    w_no_idx_orig = sum(orig_weights(jx));
    w_no_idx_final = sum(orig_weights)-sum_wix;
    new_weights(jx) = ...
        H0A0_sec_binsMod.mkt_weight(jx)*(w_no_idx_final)/w_no_idx_orig;
    
    mult_vec = new_weights./orig_weights;
    mult_vec(isnan(mult_vec))=0;
    mult_vec(mult_vec==inf,1)=0;
    mult_vec = mat2dataset(mult_vec);
    mult_vec.Properties.VarNames(end)={'mult'};    
        
    
    
    
end
