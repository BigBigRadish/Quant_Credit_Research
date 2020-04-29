function [ AnaAgg ] = IdxAnaAgg( ds, col )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Ana = ds(:,[col,10,6:7,11:24,26]);
aux_str = strcat('Ana.',Ana.Properties.VarNames{1});
groupNameList = unique(eval(aux_str));


AnaAgg = zeros(size(groupNameList,1),size(Ana,2));
AnaAgg = mat2dataset(AnaAgg);
AnaAgg.Properties.VarNames = Ana.Properties.VarNames;
AnaAgg(:,1) = mat2dataset(groupNameList);

for i = 1:size(AnaAgg,1)
    
    % Ana.ML_Level_3_Name was replaced by eval function in below line
    tmp = Ana(eval(aux_str)==groupNameList(i),:);
    weight = sum(tmp.Mkt_Pct_Weight);

    tmp(1,3:end) = mat2dataset(sum(dn(tmp(:,2))*ones(1,size(tmp,2)-2).*dn(tmp(:,3:end)),1)/weight);
    tmp(2:end,:)=[];
    tmp{1,2} = weight;
    
    AnaAgg(i,:) = tmp;
    
end  



% clear i tmp weight Ana groupNameList AnaAgg aux_str



end

