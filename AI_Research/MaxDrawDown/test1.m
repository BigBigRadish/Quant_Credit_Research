len = size(rtn,1)
per = 12

for i = 1:(len -per+1)
    
    [MDD(i,1), MDDs(i,1), MDDe(i,1), MDDr(i,1)] = ...
        MAXDRAWDOWN(rtn(i:i+per-1));
end;
    