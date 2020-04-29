function varargout = dsTimes( ds1, ds2 )
%UNTITLED3 Multiplies element by element numeric contents of two datasets.
%   Detailed explanation goes here

    if nargin ~= 2
        error('ds_times:argChk', 'Wrong number of input arguments')
    end

    if nargout > 2
        error('dsSum:outChk','Number of outputs cant be greater than 2.')
    end
    
    varargout = cell(1,nargout);
    
    % check size of inputs match
    [m1, n1] = size(ds1);
    [m2, n2] = size(ds2);
    if m1~=m2 || n1~=n2
       error('ds_times:sizeChk', 'Sizes of dataset inputs are different')
    end
    
    if isnumeric(ds1{1,1}) && isnumeric(ds2{1,1})
        ds1 = double(ds1);
        ds1(isnan(ds1)) = 0;
        ds2 = double(ds2);
        ds2(isnan(ds2)) = 0;
        
        if nargout == 1
            varargout{1}=  ds1.*ds2;
        else
            varargout{1} = { {isnan(ds1)},{isnan(ds2)}};
            varargout{2}=  ds1.*ds2;
        end
         
    else
        error('ds_times:argTypeChk', 'One or both arguments are not of numeric type')
    end

end

