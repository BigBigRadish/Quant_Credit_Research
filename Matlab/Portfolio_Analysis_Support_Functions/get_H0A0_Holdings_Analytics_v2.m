function [ Data ] = get_H0A0_Holdings_Analytics_v2(date, faceValMin)
% Get H0A0 constituent analytics for particular end of month date.
%
% NOTE:
%   Does not return column with flag to indicate if financials are
%   available. The function 'get_H0A0_Data' which returns both a
%   dataset with analytics and a dataset with financials, adds a 
%   column to the analytics dataset with a flag to indicate if
%   financials are available for each index constituent.
%
% Inputs:
% 1. 'date': string date in format 'yyyy-mm-dd'.
%    The date has to be a month end.
% 2. 'faceValMin': filters constituent bonds with a face value
%   lower than variable. Set to '0' if you want ALL constituents.

%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'dataset');
% setdbprefs('DataReturnFormat','structure');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%Make connection to database.  Note that the password has been omitted.
%Using JDBC driver.
conn = database('Xpressfeed', '', '', 'Vendor', 'MICROSOFT SQL SERVER',...
    'Server', 'GFISQL', 'PortNumber', 1433, 'AuthType', 'Windows');

sqlquery =  ['exec sp_get_H0A0_Holdings_Analytics_v2 '  '''' date ''''...
    ',' '''' faceValMin ''''];

curs = exec(conn,sqlquery); 

curs = fetch(curs);
close(curs);

%Assign data to output variable
Data = curs.Data;

%Close database connection.
close(conn);

%Clear variables
clear curs conn


end
