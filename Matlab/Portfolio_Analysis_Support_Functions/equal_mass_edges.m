function [bin_edges] = equal_mass_edges(ds,w_col,s_col,varargin)
% equal_mass_edges calculates edges to generate buckets with equal mass
%   for a given portfolio and a particular metric (ytw, stw, etc), a vector
%   with bucket edges 'bin_edges' is generated so that for each
%   bin_edge(i) (i=2:end-1) the weighted contribution of the securities with metric
%   value between 0 and bin_edge(i) corresponds to bins(i-1) % of the
%   overall portfolio metric. Assuming ytw_min and ytw_max are the smallest
%   and largest yields in the portfolio, a value of (ytw_min-1) and
%   (ytw_max+1) are added to the front and back of the 'bin_edges' vector
%   so that when used to classify securities into a particular bucket, all
%   securities of the securities fall within a bucket.
%
%   For example:
%   Metric = ytw
%   ytw_portfolio = 6.4
%   bins = [25 50 75]
%   ytw_min = 0.5
%   ytw_max = 12
%   bin_edges = [-0.5, 4, 6, 10, 13]
%
%   the cumulative weighted ytw of the securities with yields between:
%   1-. 0 and 4, is 25% of ytw_portfolio, or 25%*6.4
%   2-. 0 and 6, is 50% of ytw_portfolio, or 50%*6.4
%   3-. 0 and 10, is 75% of ytw_portfolio, or 75%*6.4
%   4-. 0 and 13, is 100% of tye ytw of the portfolio, or 6.4 (by default,
%   since the last bin edge is greater than the greater ytw, all securities
%   will be included.

if nargin == 3 
    bins = [5 10 20 40 60 80 90 95];
elseif nargin ==4
    bins = varargin{1};
else
    error('equal_mass_edges:argChk','Wrong number of input arguments');
end


wy = double(ds(:,[w_col,s_col]));

wy = [wy prod(wy,2)];

[~, ix] = sort(wy(:,2));

wy = wy(ix,:);

sorted_prod_cumsum = cumsum(wy(:,3));
sorted_prod_cumsum = sorted_prod_cumsum /sorted_prod_cumsum(end);


bins_ix = zeros(1,size(bins,2));
for i = 1:size(bins,2)
    
   bins_ix(1,i) = sum(sorted_prod_cumsum<=bins(i)/100);
   
end

bin_edges = wy(bins_ix,2);

bin_edges = [min(wy(:,2))-1 ;
    bin_edges ;
    max(wy(:,2))+1]';


end