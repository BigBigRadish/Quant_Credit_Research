function [out_stats] = get_finDataStats(finDs)
%get_finDataStats generates info of available financial data
%
%% Beg of month number of companies that have reported prior quarter financials
% Output: Cell array 'C' in file 'FinancialDataStats.mat'
% Column 1 = beginning of month. date at which availability of financias is
% evaluated.
% Column 2 = calendar year of prior calendar quarter
% Column 3 = prior calendar quarter
% Column 4 = calendar year of quarter before prior calendar quarter.
% Column 5 = calendar quarter before prior calendar quarter.
% Column 6 = number of unique issuers.
% Column 7 = number of unique issuers with available financials at beginning 
% of month.
% Column 8 = number of financials corresponding to prior calendar quarter.
% Column 9 = number of financials corresponding to calendar quarter before
% prior calendar quarter.

%Inputs
% All_H0A0Fin_combined = combined financial data.
% inputs = contains beginning of month date, performance eval date, and
% corresponding calendar years and quarters information.

load('EndOfMonthDates','inputs_ds');

% Find number of months with financial data
dt_list = unique(finDs.beg_dt);
num_months = size(dt_list,1);
    
C = cell(num_months,11);

for i = 1:num_months;
    
    date = dt_list(i);
    
    dt_r = find(inputs_ds.beg_dt==datestr(date,'yyyy-mm-dd'));
    A = finDs(finDs.beg_dt==date,:);
    %r = size(A,1);
    
    if size(A,1)~=0
        cur_yr = double(inputs_ds(dt_r,3));
        cur_qt = double(inputs_ds(dt_r,4));
        pr_yr = double(inputs_ds(dt_r,5));
        pr_qt = double(inputs_ds(dt_r,6));
        
        yesData_idx = ~any(ismissing(A),2);
        yesData_weight = sum(A.Mkt_Pct_Weight(yesData_idx));
        
        [~, ia, ~] = unique(A(:,[4,8]));
        unique_idx = zeros(size(A,1),1);
        unique_idx(ia,1) = 1;
        
        A = A(yesData_idx & unique_idx,:);
        
        cur_idx = A.calendarYear==cur_yr & A.calendarQuarter==cur_qt;
        pr_idx = A.calendarYear == pr_yr & A.calendarQuarter==pr_qt;
        
        C{i,1} = datestr(date,'yyyy-mm-dd');
        C{i,2} = date;
        C{i,3} = cur_yr;
        C{i,4} = cur_qt;
        C{i,5} = pr_yr;
        C{i,6} = pr_qt;
        C{i,7} = sum(unique_idx);
        C{i,8} = sum(yesData_idx & unique_idx);
        C{i,9} = sum(cur_idx);
        C{i,10} = sum(pr_idx);
        C{i,11} = yesData_weight;
        
        
    end

end



new_names = {'beg_dt','beg_dt_num','cur_yr','cur_qt','pr_yr','pr_qt','num_issuers',...
            'issuers_with_findata','findata_cur_calqt','findata_pr_calqt',...
            'mkt_weight_with_finData'};

out_stats = cell2dataset(vertcat(new_names,C));

clear A ia unique_idx r yesData_idx date cur_yr cur_qt pr_yr pr_qt i j ...
        cur_idx num_months pr_idx new_names C All_H0A0Fin_combined ...
        inputs inputs_ds dt_r dt_list finDs

end
% save('FinancialDataStats','C')