clear

%Set preferences with setdbprefs.
setdbprefs('DataReturnFormat', 'dataset');
% setdbprefs('DataReturnFormat','structure');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');




%Make connection to database.  Note that the password has been omitted.
%Using JDBC driver.
conn = database('Xpressfeed', '', '', 'Vendor', 'MICROSOFT SQL SERVER', 'Server', 'GFISQL', 'PortNumber', 1433, 'AuthType', 'Windows');



idxName = 'H0A0';
date = '2013-04-30';
combo = '20';
faceValMin = '0';
year = '2012';
quarter = '4';
exclusive = '1';
ultimate = '0';


% sqlquery = ['exec sp_get_Idx_CompanyIds_Metrics ' '''' year '''' ',' '''' quarter '''' ',' '''' idxName '''' ',' '''' date '''' ',' '''' faceValMin '''' ]
% sqlquery = ['exec sp_get_Idx_Holdings_CompanyIds ' '''' idxName '''' ',' '''' date '''' ',' '''' faceValMin '''' ]

sqlquery = ['exec sp_get_Idx_Holdings_CompanyIds_Metrics '  '''' idxName '''' ',' '''' date '''' ',' '''' faceValMin '''' ',' '''' year '''' ',' '''' quarter ''''  ...
            ',' '''' exclusive '''' ',' '''' ultimate ''''];

% sqlquery = ['select * from ftn_get_Idx_Holdings(' '''' date '''' ',' '''' idxName '''' ',' '''' faceValMin '''' ')' ]

% sqlquery3 =  ['exec sp_get_MkyCombo_CorpHoldings_Analytics ' '''' idxName '''' ',' '''' date '''' ',' '''' combo '''' ];

% sqlquery =  ['exec sp_get_MkyCombo_AllHoldings ' '''' date '''' ',' '''' combo '''' ]

% sqlquery =  ['exec sp_get_MkyCombo_CorpHoldings ' '''' date '''' ',' '''' combo '''' ]

% sqlquery =  ['exec sp_get_MkyCombo_CorpHoldings_Analytics  ' '''' idxName '''' ',' '''' date '''' ',' '''' combo '''' ]

% sqlquery =  ['exec sp_get_MkyCombo_CorpHoldings_CompanyIds ' '''' date '''' ',' '''' combo '''' ]


% sqlquery =  ['exec sp_get_MkyCombo_CompanyIds_Metrics ' '''' year '''' ',' '''' quarter '''' ',' '''' date '''' ',' '''' combo '''' ]


% sqlquery3 = ['exec sp_get_Idx_Holdings_Analytics ''H0A0''' ',' '''2013-04-30'',' '0']
% 

% sqlquery = ['exec sp_get_MkyCombo_CorpHoldings_CompanyIds_Metrics ' '''' year '''' ',' '''' quarter '''' ',' '''' combo '''' ',' '''' date '''' ...
%             ',' '''' exclusive '''' ',' '''' ultimate '''']

% sqlquery = ['select * from ftn_get_MkyCombo_CorpHoldings(' '''' date '''' ',' '''' combo '''' ')' ]        
        

% sqlquery1 =  ['exec sp_get_Idx_Holdings_Analytics ' '''' idxName '''' ',' '''' date '''' ',' '''' faceValMin '''' ];
% sqlquery4 = ['exec sp_get_Idx_Holdings_CompanyIds_Metrics '  '''' year '''' ',' '''' quarter '''' ',' '''' idxName '''' ',' '''' date '''' ',' '''' faceValMin '''' ...
%             ',' '''' exclusive '''' ',' '''' ultimate ''''];



 curs = exec(conn,sqlquery);  %use sqlquery, sqlquery2, or sqlquery3 depending on the command you want to execute.



curs = fetch(curs);
close(curs);

%Assign data to output variable
untitled = curs.Data;


%Close database connection.
close(conn);

%Clear variables
clear curs conn