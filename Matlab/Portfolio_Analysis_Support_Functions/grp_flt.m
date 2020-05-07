function [ idx ] = grp_flt(dset, grp_col, flt_col, pctile_bottom, pctile_top )
%grp_flt returns idx to records with value within the specified bottom/top ptcile
%
% subgroup filter
% grp_col: number of column which indicates grouping field.
% flt_col: number of column on which filtering will occur.
% pctile_bottom and pctile_top: percentiles to exclude

ds = dset(:,[grp_col flt_col]);
ds_str1 = strcat('ds.',ds.Properties.VarNames{1});
ds_str2 = strcat('ds.',ds.Properties.VarNames{2});
% tmp_str1 = strcat('tmp.',ds.Properties.VarNames{1});
tmp_str2 = strcat('tmp.',ds.Properties.VarNames{2});
groupNameList = unique(eval(ds_str1));
[r,~] = size(ds);
%idx = logical(zeros(z,1));
idx = zeros(r,1);


    for i=1:size(groupNameList)

        tmp = ds(eval(ds_str1)==groupNameList(i),:);

        lower_lim = prctile(eval(tmp_str2),pctile_bottom);
        upper_lim = prctile(eval(tmp_str2),pctile_top);
        idx = idx | ( eval(ds_str2)>lower_lim & eval(ds_str2)<upper_lim & ...
                        eval(ds_str1)==groupNameList(i) );


    end


end

