function [ AnaAggF, AnaAggP ] = IdxAnaAgg( Ana)
% IdxAnaAgg Determines groups market weighted aggregates.
%   1st column of input is grouping variable (has to be nominal value).
%   2nd column of input is market weight of security.
%   Other columns include analytics to aggregate.
%   Other columns have to include 'reportingTemplateTypeId' column.


aux_str = strcat('Ana.',Ana.Properties.VarNames{1});
groupNameList = unique(eval(aux_str));


AnaAggF = zeros(size(groupNameList,1),size(Ana,2)+1);
AnaAggF = mat2dataset(AnaAggF);
AnaAggF.Properties.VarNames = horzcat(Ana.Properties.VarNames,{'data_Weight'});
AnaAggF(:,1) = mat2dataset(groupNameList);
AnaAggP = AnaAggF;

for i = 1:size(AnaAggF,1)
    
    % Ana.ML_Level_3_Name was replaced by eval function in below line
    tmpf = Ana(eval(aux_str)==groupNameList(i),:);
    tmpp = Ana(eval(aux_str)==groupNameList(i) & ~isnan(Ana.reportingTemplateTypeId),:);
    weight = sum(tmpf.mkt_weight);
    weight_info = sum(tmpp.mkt_weight);
    %I = isnan(tmpf.reportingTemplateTypeId);
    %weight_info = sum(tmpf.Mkt_Pct_Weight(~I,:));

    if not(isempty(tmpf))
        tmpf(1,3:end) = mat2dataset(sum(dn(tmpf(:,2))*ones(1,size(tmpf,2)-2).*dn(tmpf(:,3:end)),1)/weight);
        tmpf(2:end,:)=[];
        tmpf{1,2} = weight;
    
        AnaAggF(i,1:end-1) = tmpf;
        AnaAggF{i,end} = weight_info;
    end
    
    if not(isempty(tmpp))
        tmpp(1,3:end) = mat2dataset(sum(dn(tmpp(:,2))*ones(1,size(tmpp,2)-2).*dn(tmpp(:,3:end)),1)/weight_info);
        tmpp(2:end,:)=[];
        tmpp{1,2} = weight_info;

        AnaAggP(i,1:end-1) = tmpp;
        AnaAggP{i,end} = weight_info;
    end

    
end  



% clear i tmp weight Ana groupNameList AnaAgg aux_str



end

