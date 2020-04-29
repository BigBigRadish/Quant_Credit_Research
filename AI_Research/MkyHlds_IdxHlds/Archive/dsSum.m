function varargout  = dsSum( v1 )
%dsSum Sum of array elements different than NaN
%   Inputs: dataset variable of numeric type

    if nargin ~= 1 
        error('dsSum:argChk','Number of inputs has to be 1')
    end

    if nargout > 2
        error('dsSum:outChk','Number of outputs cant be greater than 2.')
    end
    
    varargout = cell(1,nargout);
    v1 = double(v1);
    v1(isnan(v1)) = 0;

    if nargout < 2 
        varargout{1} = sum(v1);
    else
        varargout{1} = isnan(v1);
        varargout{2} = sum(v1);
    end
    
    
    
    
end

