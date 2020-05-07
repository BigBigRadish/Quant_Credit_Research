function [out_ds] = ini_ds(repeat_num,data_array,varargin)
% ini_ds concatenates vertically an array or dataset to itself a given number of times
%   Input number can be 2 or 3
%   When data_array is a dataset, only two inputs are needed.
%   When data_array is a cell_array, a 3rd input (a cell string array)
%   specifying column headings is needed.

    if nargin ==3 && iscell(data_array) && iscellstr(varargin{1}) ...
            && numel(data_array)==numel(varargin{1})

        data_array = cell2dataset(data_array,'VarNames',varargin{1});

    end
    
    if nargin==2 || nargin==3
        if isa(data_array,'dataset')

            out_ds =data_array;        
            for i=2:repeat_num

                out_ds(i,:)=out_ds(i-1,:);
            end     

        else

            out_ds=[];

        end
    else
        out_ds=[];
    end


end