function [ AnaAgg ] = IdxFinAgg_v2( ds, col )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% ds = IdxFin;
% col = 4;

Ana = ds(:,[col,6,13:21]);
aux_str = strcat('Ana.',Ana.Properties.VarNames{1});
groupNameList = unique(eval(aux_str));


AnaAgg = zeros(size(groupNameList,1),size(Ana,2)+1);
AnaAgg = mat2dataset(AnaAgg);
AnaAgg.Properties.VarNames = horzcat(Ana.Properties.VarNames,{'data_Weight'});
AnaAgg(:,1) = mat2dataset(groupNameList);

for i = 1:size(AnaAgg,1)
    
    % Ana.ML_Level_3_Name was replaced by eval function in below line
    tmp = Ana(eval(aux_str)==groupNameList(i),:);
    weight = sum(tmp.Mkt_Pct_Weight);
    I = isnan(tmp.reportingTemplateTypeId);
    weight_noinfo = sum(tmp.Mkt_Pct_Weight(~I,:));

    tmp(1,3:end) = mat2dataset(sum(dn(tmp(:,2))*ones(1,size(tmp,2)-2).*dn(tmp(:,3:end)),1)/weight);
    tmp(2:end,:)=[];
    tmp{1,2} = weight;
    %tmp.dataWeight(1) = weight_noinfo;
    
    AnaAgg(i,1:end-1) = tmp;
    AnaAgg{i,end} = weight_noinfo;
    
end  



% clear i tmp weight Ana groupNameList AnaAgg aux_str





