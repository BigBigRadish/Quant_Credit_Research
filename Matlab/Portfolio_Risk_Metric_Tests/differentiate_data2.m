function [diff1, diff2, issuer_persist] = differentiate_data2(tabular_ds,group_var,subgroup_var, size_period)

%% code to generate inputs to function
% group_var = {'lvl_3'};
% subgroup_var = {'tkr','companyId'};
% grouping_var = {'lvl_3'};
% size_period = 3;
% 
% % Get simulation details
% [control] = create_control_structure('attrib3');
% % Retrieve Idx Analytics and Financial data
% [in_c,~,IdxAna,IdxFin,~,IdxFaceVal] = get_demo_data(control);
% 
% [all_risk_metric] = run_risk_metric(IdxAna,IdxFin,in_c,group_var);
% rm_ds = all_risk_metric(all_risk_metric.issuers==1,[1 5 6 7 8]);
% [rm_tabular] = tabulate_time_dependent_data(rm_ds,[group subgroup_var],{'risk_metric'});

%%
% determine at each point in time those issuers that are present in the
% next time period of interest.
% determine risk metric percentile of securities within each group, only
% taking into account those securities that are present in the next time
% period. That way a change in an issuer ranking will be due to
% a change of its risk metric relative to the issuers present at
% the beginning of the period.

num_grp_var = size(group_var,2)+size(subgroup_var,2);

rm_data = double(tabular_ds(:,num_grp_var+1:end));
issuer_persist = rm_data(:,size_period+1:end)-rm_data(:,1:end-size_period);
issuer_persist = ~isnan(issuer_persist);
%issuer_persist = mat2dataset(issuer_persist,'VarNames',tabular_ds.Properties.VarNames(4:end-size_period));

num_groups = 1;
groupNameList = [];
if ~isempty(group_var)
    grp_col = get_dsColNum(tabular_ds.Properties.VarNames,group_var);
    groupNameList = unique(tabular_ds(:,grp_col));
    num_groups = size(groupNameList,1);
end

diff1 = NaN*ones(size(issuer_persist));
diff2 = NaN*ones(size(issuer_persist(:,num_grp_var+1:end)));
col_names = tabular_ds.Properties.VarNames(num_grp_var+1:end-size_period);

for i=1:size(issuer_persist,2)
    
    for j=1:num_groups
        
        grp_flt = ones(size(issuer_persist,1),1);
        if ~isempty(group_var) 
            aux_str = ['tabular_ds.' group_var{1},'==groupNameList.',group_var{1},'(j)'];
            grp_flt = eval(aux_str);
            %grp_flt = tabular_ds(:,grp_col)== groupNameList{j}; % ;
        end

        grp_flt2 = issuer_persist(:,i) & grp_flt;
        
        
         %imod = 3+i; % 3 can vary depending on number of non_tabular data
         %risk_val = double(tabular_ds(grp_flt,col_names(1,[imod-size_period;imod,imod+size_period])));
         risk_val = rm_data(grp_flt2,[i,i+size_period]);
         [~, sort_rsk] = sort(risk_val);
         risk_val(sort_rsk(:,1),1)= (1:size(risk_val,1))';
         risk_val(sort_rsk(:,2),2)= (1:size(risk_val,1))';
         diff1(grp_flt2,i) = risk_val(:,2)-risk_val(:,1);

         
         
         if i>size_period
             grp_flt2 = issuer_persist(:,i) & issuer_persist(:,i-size_period) & grp_flt;
             
             risk_val = rm_data(grp_flt2,[i-size_period,i,i+size_period]);
             [~, sort_rsk] = sort(risk_val);
             risk_val(sort_rsk(:,1),1)= (1:size(risk_val,1))';
             risk_val(sort_rsk(:,2),2)= (1:size(risk_val,1))';
             risk_val(sort_rsk(:,3),3)= (1:size(risk_val,1))';
             diff2(grp_flt2,i-size_period) = risk_val(:,3)- 2*risk_val(:,2)+ risk_val(:,1);
         end
        
    end
    
end

diff1 = mat2dataset(diff1,'VarNames',col_names);

diff2 = mat2dataset(diff2,'VarNames',col_names(4:end));



% 
% 
% % [all_group_vals] = cross_section_aggregation(IdxAna,IdxFin,in_c,{'tkr','companyId'},{'oas','eom_oas'},'equal');
% % name cross_section_aggregation???
% [all_group_vals] = cross_section_aggregation(IdxAna,IdxFin,in_c,{'tkr','companyId'},{'oas','tot_rtn'},'mkt');% 
% 
% 
% [all_buckets] = run_bucket_portfolios(IdxAna,IdxFin,all_risk_metric,in_c,grouping_var);
