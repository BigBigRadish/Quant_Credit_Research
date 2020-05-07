close all;
clc;
clear;

% load('risk_metric_change_vs_Oas_Rtn_change')

% %% code to generate inputs to function
% group_var = {'lvl_3'};
% subgroup_var = {'tkr','companyId'};
% size_period = 3;
% % 
% % Get simulation details
% [control] = create_control_structure('attrib3');
% % Retrieve Idx Analytics and Financial data
% [in_c,~,IdxAna,IdxFin,~,IdxFaceVal] = get_demo_data(control);
% 
% [all_risk_metric] = run_risk_metric(IdxAna,IdxFin,in_c,group_var);
% rm_ds = all_risk_metric(all_risk_metric.issuers==1,[1 5 6 7 8]);
% [rm_tabular] = tabulate_time_dependent_data(rm_ds,[group_var subgroup_var],{'risk_metric'});

% % find speed and accel of variable tabulated ('risk_metric') in our case.
% [speed, accel, issuer_persist] = differentiate_data2(rm_tabular,group_var,subgroup_var, size_period);
% 
% % aggregate monthly selection returns by issuer
% [all_issr_agg_vars] = cross_section_aggregation(IdxAna,IdxFin,in_c,subgroup_var,{'oas','tot_rtn'},'mkt');

%% Need to look if modification of attribution procedures is helpful




