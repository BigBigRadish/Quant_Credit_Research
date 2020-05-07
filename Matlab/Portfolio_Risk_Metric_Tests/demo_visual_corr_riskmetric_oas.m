
clear;
clc;
close all;
load('visual_corr_riskmetric_oas');

figH = figure;

    for iaux=1:size(in_c,1)

        av = all_group_vals(all_group_vals.beg_dt==datenum(in_c{iaux,1}),:);
        ri = all_risk_metric(all_risk_metric.beg_dt==datenum(in_c{iaux,1}),:);
        bu = all_buckets(all_buckets.beg_dt==datenum(in_c{iaux,1}),:);  

%         av = all_group_vals;
%         ri = all_risk_metric;
        ri.bucket = bu.bucket;
        ri = ri(ri.issuers==1,:);

        oas = ones(size(ri,1),1)*NaN;

        for i=1:size(ri,1)

            oas(i,1) = av(av.tkr==ri.tkr(i) & av.companyId==ri.companyId(i),'oas');
        end

        ri.oas = oas;

        stats = grpstats(ri,'lvl_3',{'mean','std'},'DataVars',{'risk_metric','oas'});

        grp_idx = ones(size(ri,1),1)==0;
            %eliminate outliers
        for i = 1:size(stats,1)

           mu_oas = stats.mean_oas(i);
           mu_rm = stats.mean_risk_metric(i);
           sigma_oas = stats.std_oas(i);
           sigma_rm = stats.std_risk_metric(i);
           
           ri.oas(ri.lvl_3 == stats.lvl_3(i)) = (ri.oas(ri.lvl_3 == stats.lvl_3(i))-mu_oas)/sigma_oas;
           ri.risk_metric(ri.lvl_3 == stats.lvl_3(i)) = (ri.risk_metric(ri.lvl_3 == stats.lvl_3(i))-mu_rm)/sigma_rm;
           %grp_idx = grp_idx | ri.oas(ri.lvl_3 == stats.lvl_3(i))>1;
           %grp_idx = grp_idx | (ri.lvl_3 == stats.lvl_3(i) & abs((ri.oas-mu)/sigma)>1);

        end
        
        ri_trim = ri(abs(ri.oas)<2 & abs(ri.risk_metric)<2 ,:);

        for i = 1:size(stats,1)

            
            subplot(4,4,i)
            X = ri_trim(ri_trim.lvl_3 == stats.lvl_3(i),'risk_metric');
            Y = ri_trim(ri_trim.lvl_3 == stats.lvl_3(i),'oas');
            group = ri_trim(ri_trim.lvl_3 == stats.lvl_3(i),'bucket');
            gscatter(X.risk_metric,Y.oas,group.bucket)
            title(cellstr(stats(i,'lvl_3')));
            set(figH,'Name',in_c{iaux,1},'NumberTitle','off');
            legend('off');

        end
        
        
    end