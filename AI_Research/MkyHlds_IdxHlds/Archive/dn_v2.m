function [ ds1 ] = dn_v2( ds1 )
%dn Converst numeric dataset to type double and zeros out NaN values
%   
        if ~isempty(ds1)
            for i = 1:size(ds1,2)
                if isa(ds1{1,i},'numeric') == 0
                    error('dn:argTypChk','Content of dataset is non-numeric')
                end
            end
            ds1 = double(ds1);
            ds1(isnan(ds1)) = 0;
        else
            
            ds1 = [];
            
        end
        

        
end

