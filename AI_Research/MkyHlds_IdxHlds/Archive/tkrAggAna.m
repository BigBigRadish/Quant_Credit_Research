% Get ticker aggregate analytics

tkrAna = IdxAna(:,[5,10,6:7,11:24,26]);
tkrList = unique(tkrAna.ticker);


tkrAnaAgg = zeros(size(tkrList,1),size(tkrAna,2));
tkrAnaAgg = mat2dataset(tkrAnaAgg);
tkrAnaAgg.Properties.VarNames = tkrAna.Properties.VarNames;
tkrAnaAgg.ticker = tkrList;

for i = 1:size(tkrAnaAgg,1)
    
    tmp = tkrAna(tkrAna.ticker==tkrList(i),:);
    weight = sum(tmp.Mkt_Pct_Weight);

    tmp(1,3:end) = mat2dataset(sum(dn(tmp(:,2))*ones(1,size(tmp,2)-2).*dn(tmp(:,3:end)),1)/weight);
    tmp(2:end,:)=[];
    tmp{1,2} = weight;
    
    tkrAnaAgg(i,:) = tmp;
    
end  

clear i tmp weight tkrAna tkrList