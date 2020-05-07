function [port] = ...
    create_bucket_portfolios_simple(num_buckets,H0A0Fin,risk_metric,...
                                    idx_issuers,grouping_var)

% num_buckets = 5;
num_sec = size(H0A0Fin,1);
% max_rank = 5;
% H0A0Fin = H0A0Fin(idx_issuers,:);
num_iss =size(H0A0Fin(idx_issuers,:),1);
risk_metric = risk_metric(idx_issuers,:);

port = H0A0Fin(:,[4,8,5]);
port_issuer = H0A0Fin(idx_issuers,[4,8,5]);

num_groups = 1;
groupNameList = [];
if ~isempty(grouping_var) 
    grp_col = get_dsColNum(port_issuer.Properties.VarNames,grouping_var);
    groupNameList = unique(port_issuer(:,grp_col));
    num_groups = size(groupNameList,1);
end


aux_bucket = NaN*ones(size(port_issuer,1),1); %risk_metric = double(ds(:,1));

for i=1:num_groups

    
	grp_flt = ones(size(port_issuer,1),1);
    if ~isempty(grouping_var) 
        aux_str = ['port_issuer.' grouping_var{1},'==groupNameList.',grouping_var{1},'(i)'];
        grp_flt = eval(aux_str);
        % grp_flt = auxAnaDS.lvl_3==groupNameList.lvl_3(i);
    end
    
    aux_risk_metric = risk_metric(grp_flt,:);
    
    [~,sort_rsk] = sort(aux_risk_metric);
    aux_risk_metric(sort_rsk,1) = (1:size(aux_risk_metric))';
    
    risk_metric(grp_flt,1) = aux_risk_metric;
    
    
    max_rank = max(risk_metric(grp_flt,1));
    
    if max_rank > 2 
    %         [~, sort_rsk] = sort(risk_val);
    %         risk_val(sort_rsk,1)= (1:size(risk_val))';    

        cutoff1 = ceil(max_rank/num_buckets);
        cutoff2 = max_rank - cutoff1+1;


        port_issuer.bucket((risk_metric<=cutoff1 & grp_flt),1) = 1;
        port_issuer.bucket(((risk_metric>cutoff1 & risk_metric< cutoff2) & grp_flt),1) = 2;
        port_issuer.bucket((risk_metric>=cutoff2 & grp_flt),1) = 3;
        
        
    end
    
    
end

% port_issuer.bucket = aux_bucket;

port.bucket = NaN*ones(num_sec,1);

for j = 1: num_iss
    
    port.bucket(port.ticker == port_issuer.ticker(j) & ...
            port.companyId == port_issuer.companyId(j))= port_issuer.bucket(j);
    
end


