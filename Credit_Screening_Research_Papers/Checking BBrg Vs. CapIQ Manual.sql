USE [Xpressfeed]

SELECT c.companyName, c.companyId, ti.tickerSymbol,e.exchangeSymbol, fi.periodEndDate,fi.filingDate,pt.periodTypeName,fp.calendarQuarter, fp.calendarYear,fd.dataItemId,di.dataItemName,fd.dataItemValue
FROM ciqCompany c
join ciqSecurity s on c.companyId = s.companyId
join ciqTradingItem ti on ti.securityId = s.securityId
join ciqExchange e on e.exchangeId = ti.exchangeId
join ciqFinPeriod fp on fp.companyId = c.companyId
join ciqPeriodType pt on pt.periodTypeId = fp.periodTypeId
join ciqFinInstance fi on fi.financialPeriodId = fp.financialPeriodId
join ciqFinInstanceToCollection ic on ic.financialInstanceId = fi.financialInstanceId
join ciqFinCollection fc on fc.financialCollectionId = ic.financialCollectionId
join ciqFinCollectionData fd on fd.financialCollectionId = ic.financialCollectionId
join ciqDataItem di on di.dataItemId = fd.dataItemId
WHERE fd.dataItemId in (1001,1002,1004,1007,1008,1009,1013,1018,1021,1030,1035,1040,1043,1048,1049,1094,1096,1104,1169,1276,1279,1297)
AND fp.periodTypeId = 1 --Annual
AND e.exchangeSymbol = 'NYSE'
AND ti.tickerSymbol = 'M' --Nestlé S.A.
AND fi.latestForFinancialPeriodFlag = 1 --Latest Instance For Financial Period
AND fp.latestPeriodFlag = 1 --Current Period
ORDER BY di.dataItemId



SELECT c.companyName, c.companyId, ti.tickerSymbol,e.exchangeSymbol, fi.periodEndDate,fi.filingDate,pt.periodTypeName,fp.calendarQuarter, fp.calendarYear,fd.dataItemId,di.dataItemName,fd.dataItemValue
FROM ciqCompany c
join ciqSecurity s on c.companyId = s.companyId
join ciqTradingItem ti on ti.securityId = s.securityId
join ciqExchange e on e.exchangeId = ti.exchangeId
join ciqFinPeriod fp on fp.companyId = c.companyId
join ciqPeriodType pt on pt.periodTypeId = fp.periodTypeId
join ciqFinInstance fi on fi.financialPeriodId = fp.financialPeriodId
join ciqFinInstanceToCollection ic on ic.financialInstanceId = fi.financialInstanceId
join ciqFinCollection fc on fc.financialCollectionId = ic.financialCollectionId
join ciqFinCollectionData fd on fd.financialCollectionId = ic.financialCollectionId
join ciqDataItem di on di.dataItemId = fd.dataItemId
WHERE fd.dataItemId in (1,10,15,21,28,34,41,82,112,139,368,373)
AND fp.periodTypeId = 1 --Annual
AND e.exchangeSymbol = 'NYSE'
AND ti.tickerSymbol = 'M' --Nestlé S.A.
AND fi.latestForFinancialPeriodFlag = 1 --Latest Instance For Financial Period
AND fp.latestPeriodFlag = 1 --Current Period
ORDER BY di.dataItemId

SELECT c.companyName, c.companyId, ti.tickerSymbol,e.exchangeSymbol, fi.periodEndDate,fi.filingDate,pt.periodTypeName,fp.calendarQuarter, fp.calendarYear,fd.dataItemId,di.dataItemName,fd.dataItemValue
FROM ciqCompany c
join ciqSecurity s on c.companyId = s.companyId
join ciqTradingItem ti on ti.securityId = s.securityId
join ciqExchange e on e.exchangeId = ti.exchangeId
join ciqFinPeriod fp on fp.companyId = c.companyId
join ciqPeriodType pt on pt.periodTypeId = fp.periodTypeId
join ciqFinInstance fi on fi.financialPeriodId = fp.financialPeriodId
join ciqFinInstanceToCollection ic on ic.financialInstanceId = fi.financialInstanceId
join ciqFinCollection fc on fc.financialCollectionId = ic.financialCollectionId
join ciqFinCollectionData fd on fd.financialCollectionId = ic.financialCollectionId
join ciqDataItem di on di.dataItemId = fd.dataItemId
WHERE fd.dataItemId in (4,95,139,400,4051,21674,21675,21676,21677,24129,24130,24131,24132,24133,24134,24135,24136,24137,100689,4047,4074,4094)
AND fp.periodTypeId = 1 --Annual
AND e.exchangeSymbol = 'NYSE'
AND ti.tickerSymbol = 'M' --Nestlé S.A.
AND fi.latestForFinancialPeriodFlag = 1 --Latest Instance For Financial Period
AND fp.latestPeriodFlag = 1 --Current Period
ORDER BY di.dataItemId



SELECT c.companyName, c.companyId, ti.tickerSymbol,e.exchangeSymbol, fi.periodEndDate,fi.filingDate,pt.periodTypeName,fp.calendarQuarter, fp.calendarYear,fd.dataItemId,di.dataItemName,fd.dataItemValue
FROM ciqCompany c
join ciqSecurity s on c.companyId = s.companyId
join ciqTradingItem ti on ti.securityId = s.securityId
join ciqExchange e on e.exchangeId = ti.exchangeId
join ciqFinPeriod fp on fp.companyId = c.companyId
join ciqPeriodType pt on pt.periodTypeId = fp.periodTypeId
join ciqFinInstance fi on fi.financialPeriodId = fp.financialPeriodId
join ciqFinInstanceToCollection ic on ic.financialInstanceId = fi.financialInstanceId
join ciqFinCollection fc on fc.financialCollectionId = ic.financialCollectionId
join ciqFinCollectionData fd on fd.financialCollectionId = ic.financialCollectionId
join ciqDataItem di on di.dataItemId = fd.dataItemId
WHERE fd.dataItemId in (2004,2005,2006,2093,2150,2160,2161,2166,4421,4422,4423,22985)
AND fp.periodTypeId = 1 --Annual
AND e.exchangeSymbol = 'NYSE'
AND ti.tickerSymbol = 'M' --Nestlé S.A.
AND fi.latestForFinancialPeriodFlag = 1 --Latest Instance For Financial Period
AND fp.latestPeriodFlag = 1 --Current Period
ORDER BY di.dataItemId