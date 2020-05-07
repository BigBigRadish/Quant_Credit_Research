function [diff1, diff2] = differentiate_data(tabular_ds, num_periods)
% clear;
% clc;
% close all;
% load('visual_corr_riskmetric_oas');
% [diff1 diff2] = differentiate_data(tabular_ds,1, {'tkr','companyId'}); 
                
                
% diff1(i) = [x(i+1)-x(i)]/(deltaX) = [x(i+1)-x(i)]
% diff2(i) = [x(i+1)-2x(i)+x(i-1)]/(deltaX^2) = [x(i+1)-2x(i)+x(i-1)]
% deltaX = 1 time period, hence deltaX^2 = 1

% Use the following command to create input to 'differentiate_data'
% function.
% [tabular_ds] = tabulate_time_dependent_data(ds,...
%                     grouping_var,target_var);
                

num_grp_col = size(grouping_var,2);
                
aux = double(tabular_ds(:,num_grp_col+1:end));
col_names = tabular_ds.Properties.VarNames(num_grp_col+1:end);



diff1 = aux(:,num_periods+1:end)-aux(:,1:end-num_periods);
d1_names = col_names(1:end-num_periods);
diff1 = mat2dataset(diff1,'VarNames',d1_names);

diff2 = aux(:,2*num_periods+1:end) - ...
        2*aux(:,1+num_periods:end-num_periods) + ...
        aux(:,1:end-2*num_periods);
d2_names = col_names(1+num_periods:end-num_periods);
diff2 = mat2dataset(diff2,'VarNames',d2_names);
