function [grp_vals] = cross_section_aggregation(Port_ds,grouping_var,target_var,agg_type)

% % Get simulation details
% [control] = create_control_structure('attrib2');
% % Retrieve Idx Analytics and Financial data
% [in_c,~,IdxAna,IdxFin,~,IdxFaceVal] = get_demo_data(control);
% [all_group_vals] = cross_section_aggregation(IdxAna,IdxFin,in_c,{'tkr','companyId'},{'oas','eom_oas'},'equal');
% [all_group_vals] = cross_section_aggregation(IdxAna,IdxFin,in_c,{'tkr','companyId'},{'oas','eom_oas'},'mkt');% 



    if ~isempty(Port_ds)

        % In numeric grouping variables set NaN values to -1 to reduce the
        % number of unique rows in grp_vals dataset below
        for i=1:size(grouping_var,2)
           if isnumeric(Port_ds{1,grouping_var(i)})
               grp_col_val = eval(strcat('Port_ds.',grouping_var{i}));
               grp_col_val(isnan(grp_col_val))=-1;
               eval(strcat(strcat('Port_ds.',grouping_var{i}),'=grp_col_val;'));
           end
        end

        ds_mean = grpstats(Port_ds,grouping_var,'mean','DataVars',target_var);
        ds_mean.Properties.VarNames = strrep(ds_mean.Properties.VarNames,'mean_','');


        % mkt weight each of the target variables
        aux_mw_vals = double(Port_ds(:,target_var));
        aux_mw_vals = aux_mw_vals.*repmat(Port_ds.mkt_weight,1,size(target_var,2));
        Port_ds(:,target_var) = mat2dataset(aux_mw_vals);


        ds_weight = grpstats(Port_ds,grouping_var,{@sum},'DataVars',['mkt_weight' target_var]);
        ds_weight.Properties.VarNames = strrep(ds_weight.Properties.VarNames,'sum_','');            
        aux_mw_vals = double(ds_weight(:,target_var));
        aux_mw_vals = aux_mw_vals./repmat(ds_weight.mkt_weight,1,size(target_var,2));
        aux_mw_vals(isnan(aux_mw_vals))=0;
        ds_weight(:,target_var) = mat2dataset(aux_mw_vals);


        aux_weight = ds_weight(:,'mkt_weight');

        if strcmp(agg_type ,'equal')
            % aux_vals(i,:) = mean(double(Ana(idx,target_var))); %.oas(idx));
            aux_vals = ds_mean(:,target_var);
        elseif strcmp(agg_type,'mkt')
            %aux_vals(i,:) = sum((Ana.mkt_weight(idx)*ones(1,size(target_var,2))).*double(Ana(idx,target_var)))/aux_weight(i,:);
            aux_vals = ds_weight(:,target_var);
        end

    end

    grp_vals = horzcat(ds_weight(:,grouping_var),aux_weight,aux_vals);
    % grp_vals = [ini_ds(size(grp_vals,1),Ana(1,'beg_dt'),'beg_dt') grp_vals];

    % Set values in grp_vals that were NaN originally back to NaN
    % since we previously set them to -1;
    for i=1:size(grouping_var,2)
       if isnumeric(grp_vals{1,grouping_var(i)})
           aux_val = eval(strcat('grp_vals.',grouping_var{i}));
           aux_val(aux_val==-1)=NaN;
           eval(strcat(strcat('grp_vals.',grouping_var{i}),'=aux_val;'));
       end
    end            
    grp_vals.Properties.ObsNames = [];

    
           
        
        
end

