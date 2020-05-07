function [output_ds] = tabulate_time_dependent_data(ds,...
                    grouping_var,target_var)%

% clear;
% clc;
% close all;
% load('visual_corr_riskmetric_oas');
% [output_ds] = tabulate_time_dependent_data(ds,{'tkr','companyId'},{'oas'});% 
% [output_ds] = tabulate_time_dependent_data(ds1,[],{'oas'});% 

                
    a = ds;
    
    for i=1:size(grouping_var,2)
       if isnumeric(a{1,grouping_var(i)})
           aux = eval(strcat('a.',grouping_var{i}));
           aux(isnan(aux))=-1;
           eval(strcat(strcat('a.',grouping_var{i}),'=aux;'));
       end
    end
    
    output_row_names = unique(a(:,grouping_var));
    
    if ~isnumeric(a.beg_dt), a.beg_dt = datenum(a.beg_dt); end
    
	% Create output dataset
    % a.beg_dt = cellstr(datestr(a.beg_dt,'xyyyy_mm_dd'));
	col_names = unique(a(:,{'beg_dt'}));
    num_output_col = size(col_names,1);
    output_col_names = cellstr(num2str(col_names.beg_dt))';
    strcat('x',output_col_names);
    aux_str = repmat('[],',[1,size(grouping_var,2)+size(output_col_names,2)]);
    aux_str = strcat('dataset(',aux_str);
    aux_str = strcat(aux_str,'''VarNames'', [grouping_var,output_col_names])');
    output_ds = eval(aux_str);


    
    for i=1:size(output_row_names,1)

        idx = ones(size(a,1),1)==1;
        for j = 1:size(grouping_var,2)
            if isnumeric(output_row_names{i,grouping_var(j)})
                if isnan(output_row_names{i,grouping_var(j)})
                    idx = idx & isnan(eval(strcat('a.',grouping_var{j})));
                else
                    idx = idx & (eval(strcat('a.',grouping_var{j})) == output_row_names{i,grouping_var(j)});
                end
            else
                idx = idx & (eval(strcat('a.',grouping_var{j})) == output_row_names{i,grouping_var(j)});
            end
        end        
        
        
        tmp_ds = a(idx,[{'beg_dt'} target_var]);
        tmp_col_names = unique(tmp_ds(:,{'beg_dt'}));
        tmp_col_names = cellstr(num2str(tmp_col_names.beg_dt));
        tmp_col_names = strcat('x',tmp_col_names);
        
        t = output_row_names(i,grouping_var);
        v = mat2dataset(ones(1,num_output_col)*NaN);
        v.Properties.VarNames = strcat('x',output_col_names);
        u = mat2dataset(double(tmp_ds(:,target_var))');
        u.Properties.VarNames = tmp_col_names;
        v(1,tmp_col_names) = u;
        %disp(i);
        output_ds = vertcat(output_ds,[t v]);
        
                
    end

    output_col_names =cellfun(@(x)str2double(x),output_col_names);
    output_col_names = cellstr(datestr(output_col_names,'xyyyy_mm_dd'))';
    output_ds.Properties.VarNames = [grouping_var output_col_names];
    
    for i=1:size(grouping_var,2)
       if isnumeric(output_ds{1,grouping_var(i)})
           aux = eval(strcat('output_ds.',grouping_var{i}));
           aux(aux==-1)=NaN;
           eval(strcat(strcat('output_ds.',grouping_var{i}),'=aux;'));
       end
    end    
    
    


                
                
                
end