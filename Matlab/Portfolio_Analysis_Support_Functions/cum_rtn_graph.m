function [  ] = cum_rtn_graph(all_summ_rtn,rtn_vec)
%cum_rtn graphs the cumulative returns at every month end.
%   Input: dataset with end of month index and constructed portfolio
%   monthly returns in columns 3 and 5 respectively.

all_summ_rtn.Properties.VarNames(rtn_vec)=strrep(all_summ_rtn.Properties.VarNames(rtn_vec),'_','');


rtn = 1 + double(all_summ_rtn(:,rtn_vec))/100;
rtn = [ones(1,size(rtn_vec,2));rtn];
cumrtn = cumprod(rtn,1);
%figure('Name','Cumulative returns at every month end.','NumberTitle','off') 
a = datenum(all_summ_rtn.beg_dt);
[Y, M, ~, ~, ~, ~] = datevec(a(end)+1);
E = eomday(Y,M);
a(end+1) = datenum(Y,M,E);

plot(a,cumrtn)
datetick('x','mmm-yy','keepticks')
title(['From ',datestr(a(1),'yyyy-mm-dd'),' to ',datestr(a(end),'yyyy-mm-dd')])
xlim([a(1) a(end)]);

grid
legend(all_summ_rtn.Properties.VarNames(rtn_vec));


end
