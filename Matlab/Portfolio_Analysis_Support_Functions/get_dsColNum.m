function [out_vec] = get_dsColNum(ds_colNames,varNames)
% get_dsColNum: get column numbers of fields in dataset
%   given the string array 'ds_colNames' of ordered dataset field names, 
%   this function retuns a vector with the column number of each string in
%   string array 'varNames'.

num_var = size(varNames,2);
out_vec = zeros(1,num_var);
num_ds_cols = size(ds_colNames,2);

for i=1:num_var
   for j=1:num_ds_cols
      if strcmp(varNames{i},ds_colNames{j})
          out_vec(i)=j;
          break;
      end
   end
end
