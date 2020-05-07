close all;
clear;

% start timer
tic


% Get simulation details
[control] = create_control_structure('attrib2');


% Retrieve Idx Analytics and Financial data
[in_c,~,IdxAna,IdxFin,~,IdxFaceVal] = get_demo_data(control);


% Determine security/issuer filter
[all_filter_idxs] = run_security_filter(IdxAna,IdxFin,IdxFaceVal,in_c);


% Determine new portfolio
[all_mult] = run_port_weights(all_filter_idxs,IdxAna,in_c,control);


IdxAna.companyId = IdxFin.companyId;
[all_H0A0_sec_binsEval] = run_get_BinValues(IdxAna,in_c,control.met_eval,control.edge_eval);
IdxAna = horzcat(IdxAna,all_H0A0_sec_binsEval(:,control.attrib_vars));
PrtAna = IdxAna;
PrtAna.mkt_weight = PrtAna.mkt_weight.*all_mult.mult;

% %% Security level attribution
% [Idx_fxd_rtn] = attrib_fixed_income_decomp(IdxAna_bin,[]);
% [Prt_fxd_rtn] = attrib_fixed_income_decomp(PrtAna_bin,Idx_fxd_rtn.spr_chg);

%% Monthly Attribution - No bins.
grouping_var = {'beg_dt'};
datavars = {'spr_dur','price','cur_cpn','tot_rtn','excess_rtn'}; %,'inc_rtn','tsy_rtn','spr_rtn','select_rtn','spr_chg'};
[IdxAna_agg_monthly] = cross_section_aggregation(IdxAna,grouping_var,datavars,'mkt');
[PrtAna_agg_monthly] = cross_section_aggregation(PrtAna,grouping_var,datavars,'mkt');

[Idx_fxd_rtn_monthly] = attrib_fixed_income_decomp(IdxAna_agg_monthly,[]);
[Prt_fxd_rtn_monthly] = attrib_fixed_income_decomp(PrtAna_agg_monthly,Idx_fxd_rtn.spr_chg);

[equity_decomp_monthly] = ...
        run_attrib_equity_decomp(Idx_fxd_rtn_monthly,Prt_fxd_rtn_monthly,Idx_fxd_rtn_monthly,...
                                {'beg_dt'},[],datenum(in_c(:,1)));



%% Monthly Attribution - YES bins.
% grouping_var = [{'beg_dt'},control.attrib_cat_vars,control.attrib_vars];
grouping_var = [{'beg_dt','lvl_3'}];
datavars = {'spr_dur','price','cur_cpn','tot_rtn','excess_rtn'};
[IdxAna_agg_bins] = cross_section_aggregation(IdxAna,grouping_var,datavars,'mkt');
[PrtAna_agg_bins] = cross_section_aggregation(PrtAna,grouping_var,datavars,'mkt');

[Idx_fxd_rtn_bins] = attrib_fixed_income_decomp(IdxAna_agg_bins,[]);
[Prt_fxd_rtn_bins] = attrib_fixed_income_decomp(PrtAna_agg_bins,Idx_fxd_rtn_bins.spr_chg);


toc
                 
%% Monthly equity decomp - Yes Bins                 
[equity_decomp_bins] = ...
        run_attrib_equity_decomp(Idx_fxd_rtn_bins,Prt_fxd_rtn_bins,Idx_fxd_rtn_monthly,...
                                {'beg_dt'},[control.attrib_cat_vars],datenum(in_c(:,1)));


% % net_iss_tgt_col = 2;
% % net_sec_tgt_col = 3;
% % 
% % [net_iss_summ] = process_attrib(all_equity_decomp,control,net_iss_tgt_col);
% % [net_sec_summ] = process_attrib(all_equity_decomp,control,net_sec_tgt_col);
% 
% [tab_select_net_iss] = tabulate_time_dependent_data(all_equity_decomp,[],{'select_net_iss'});
% [tab_select_net_sec] = tabulate_time_dependent_data(all_equity_decomp,[],{'select_net_sec'});
% 
% % [tot_rtn2] = tabulate_time_dependent_data(all_bin_equity_decomp,...
% %         [control.attrib_cat_vars,control.attrib_vars],{'tot_rtn'});
% 
% 
% % Graph cumulative returns
% figure('Name','Cumulative returns at every month end.','NumberTitle','off')
% subplot(2,2,1)
% cum_rtn_graph(all_summ_rtn,[2:3]);
% subplot(2,2,2)
% cum_rtn_graph(all_summ_rtn,[6:7]);
% subplot(2,2,3)
% cum_rtn_graph(all_summ_rtn,[8:9]);
% subplot(2,2,4)
% cum_rtn_graph(all_summ_rtn,[10:11]);
% 
% % end timer
% toc
% 
% 
% clear binNum in_c in_ds matF matH net_iss_tgt_col net_sec_tgt_col
% 
% 
% 
% 
