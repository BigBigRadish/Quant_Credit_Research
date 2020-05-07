function [port_idx] = ...
    create_bucket_portfolios(num_buckets,ds,risk_metric,grouping_var)

% num_buckets = 3;
num_sec = size(ds,1);
% max_rank = 5;



num_groups = 1;
groupNameList = [];
if ~isempty(grouping_var) 
    grp_col = get_dsColNum(ds.Properties.VarNames,grouping_var);
    groupNameList = unique(ds(:,grp_col));
    num_groups = size(groupNameList,1);
end

port_idx = zeros(num_sec,num_buckets);
%risk_metric = double(ds(:,1));

for i=1:num_groups

    
	grp_flt = ones(size(ds,1),1);
    if ~isempty(grouping_var) 
        aux_str = ['ds.' grouping_var{1},'==groupNameList.',grouping_var{1},'(i)'];
        grp_flt = eval(aux_str);
        % grp_flt = auxAnaDS.lvl_3==groupNameList.lvl_3(i);
    end
    
    max_rank = max(ds(grp_flt,1));

%     risk_metric = ceil(rand(num_sec,1)*max_rank);
    idx = find(grp_flt==1);

    if num_buckets >= max_rank
        % aux_dest = round(rand(num_buckets,1)*num_buckets);

%         map_vec = [1:num_buckets]';%[num_buckets:-1:1]';
%         x = round(map_vec*max_rank/num_buckets);
        x = round(((1:num_buckets)')*max_rank/num_buckets);
        % map_vec1 = [map_vec x];
        % new_rank = zeros(num_sec,1);

        for i=1:size(idx); % num_sec

            port_idx(idx(i),:) = (x==risk_metric(idx(i)))';

        end

    else

        % map_vec = [1:max_rank]';%[num_buckets:-1:1]';
        x = round(map_vec*num_buckets/max_rank);
        %map_vec1 = [map_vec x];
        % new_rank = zeros(num_sec,1);

        for i=1:size(idx)

            port_idx(idx(i),x(risk_metric(idx(i))))= 1;

        end    


    end
    
end

port_idx = port_idx==1;