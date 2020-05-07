function [ Data ] = get_H0A0_Holdings_CompanyIds_Metrics(date, faceValMin, year, quarter, exclusive, ultimate )
% Get H0A0 constituent financials for particular end of month date.
%
% Inputs:
% 1. 'date': string date in format 'yyyy-mm-dd'.
%    The date has to be a month end.
% 2. 'faceValMin': filters constituent bonds with a face value
%   lower than variable. Set to '0' if you want ALL constituents.
% 3. 'year': calendar year to get financials from.
% 4. 'quarter': calendar quarter to get financials from.
% 5. 'exclusive': If set to 1, get metrics exclusively from the company
%   specified by @ultimate flag. If set to 0, then get metrics from the
%   alternate related company if the desired company (as specified by
%   @ultimate flag) has no related metrics.
% 6. 'ultimate' If set to 1, get metrics from the ultimate parent.
%   If set to 0, get metrics from the immediate related company.

%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'dataset');
% setdbprefs('DataReturnFormat','structure');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%Make connection to database.  Note that the password has been omitted.
%Using JDBC driver.
conn = database('Xpressfeed', '', '', 'Vendor', 'MICROSOFT SQL SERVER', 'Server', 'GFISQL', 'PortNumber', 1433, 'AuthType', 'Windows');

sqlquery = ['exec sp_get_H0A0_Holdings_CompanyIds_Metrics_v2 ' '''' date '''' ',' '''' faceValMin '''' ',' '''' ...
            num2str(year) '''' ',' '''' num2str(quarter) ''''  ...
            ',' '''' exclusive '''' ',' '''' ultimate ''''];

        
        
curs = exec(conn,sqlquery);  %use sqlquery, sqlquery2, or sqlquery3 depending on the command you want to execute.


curs = fetch(curs);
close(curs);


%Assign data to output variable
Data = curs.Data;
% Data.Properties.VarNames{15} = 'SecDebtPct';
% Data.Properties.VarNames{16} = 'NetLev';
% Data.Properties.VarNames{17} = 'NetLev_CapExAdj';
% Data.Properties.VarNames{18} = 'IntCov';
% Data.Properties.VarNames{19} = 'IntCov_CapExAdj';
% Data.Properties.VarNames{21} = 'EBITDA_CapExAdj';

%Close database connection.
close(conn);

%Clear variables
clear curs conn
        
        
        
end

