function combMat = all_combinations(varargin)
% ALL_COMBINATIONS: Cross product of elements in a list of arrays
% The input arrays have to be of the same datatype.
% The output is an array of the same type as the inputs, where each row
% represents a possible combination.
%
% For example: they should all be cell arrays (preferable when the 
% elements in the arrays are of various datatypes), all of them should
% be numeric vectors.
%
% Use examples:
% 1-. output = all_combinations({'ytw'},{'a','b'},{3,4});
% output = {
%    'ytw'    'a'    [3]
%    'ytw'    'a'    [4]
%    'ytw'    'b'    [3]
%    'ytw'    'b'    [4]}
    
% 2-. output = all_combinations([1,2],[3,4]);
% output = [
%      1     3
%      1     4
%      2     3
%      2     4]

  sizeVec = cellfun('prodofsize', varargin);
  indices = fliplr(arrayfun(@(n) {1:n}, sizeVec));
  [indices{:}] = ndgrid(indices{:});
  combMat = cellfun(@(c,i) {reshape(c(i(:)), [], 1)}, ...
                    varargin, fliplr(indices));
  combMat = [combMat{:}];
end