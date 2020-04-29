clear
clc
load('ReturnStream.mat')
RS = ReturnStreams(:,2:5);
DT = ReturnStreams(:,1);

RS = 1 + RS/100;

dbaRtn = [1;RS(75:end,1)];
uncRtn = [1;RS(178:end,2)];
ibRtn = [1;RS(178:end,3)];

dbaDT = DT(74:end);
uncDT = DT(177:end);
ibDT = DT(177:end);


db_cr = [cumprod(dbaRtn)];
unc_cr = [cumprod(uncRtn)];
ib_cr = [cumprod(ibRtn)];

db_r = log(db_cr(2:end)./db_cr(1:end-1));
unc_r = log(unc_cr(2:end)./unc_cr(1:end-1));
ib_r =  log(ib_cr(2:end)./ib_cr(1:end-1));


%rtn = db_r;
%rtn = unc_r;
rtn = ib_r;

len = size(rtn,1);
lin = 0:len;
per = 12;

for i = 1:(len -per+1)
    
    if i == 94
        i;
    end
    
    [MDD(i,1), MDDs(i,1), MDDe(i,1), MDDr(i,1)] = ...
        MAXDRAWDOWN(rtn(i:i+per-1));
end;

plot(lin,unc_cr)


