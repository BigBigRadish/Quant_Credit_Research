function piHat = estimatePiR(iRC,nSuppRC)

tPeriods = size(iRC,1);
piHat    = zeros(nSuppRC, nSuppRC);

for i = 1:nSuppRC
    for j = 1:nSuppRC
        piHat(i,j) = sum(sum((((iRC(2:tPeriods,:)-31).*2)==j)&(((iRC(1:tPeriods-1,:)-31).*2)==i)))/sum(sum((((iRC(1:tPeriods-1,:)-31).*2)==i)));
    end
end


end