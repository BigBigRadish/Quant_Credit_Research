function [ Data ] = get_Idx_Holdings_Analytics(idxName,date, faceValMin)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'dataset');
% setdbprefs('DataReturnFormat','structure');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');


%Make connection to database.  Note that the password has been omitted.
%Using JDBC driver.
conn = database('Xpressfeed', '', '', 'Vendor', 'MICROSOFT SQL SERVER', 'Server', 'GFISQL', 'PortNumber', 1433, 'AuthType', 'Windows');

sqlquery = ['exec sp_get_Idx_Holdings_Analytics '  '''' idxName '''' ',' '''' date '''' ',' '''' faceValMin ''''];


curs = exec(conn,sqlquery);  %use sqlquery, sqlquery2, or sqlquery3 depending on the command you want to execute.


curs = fetch(curs);
close(curs);


%Assign data to output variable
Data = curs.Data;


%Close database connection.
close(conn);

%Clear variables
clear curs conn






end
