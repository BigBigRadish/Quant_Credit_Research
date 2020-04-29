
% IdxInfo.ticker = nominal(IdxInfo.ticker)
% load IdxDatasets

% getname=@(varargin) inputname(1);

% strcat('nominal('&getname(IdxInfo)&'.',VarNames{1,1})
% [m, n] = size(IdxInfo);
VarNames = who';

for j = 1:length(VarNames)
    
    if isa(eval(VarNames{j}),'dataset')

        FieldNames = eval(strcat(VarNames{j},'.Properties.VarNames'));
     
        
        
        for i = 1:length(FieldNames)

            if isa(eval(strcat(VarNames{j},'{1,i}')),'char')

                aux_str = strcat(VarNames{j}, '.',FieldNames{1,i},' = ',' nominal(',VarNames{j}, '.',FieldNames{1,i},')',char(59));
                eval(aux_str);

            end

        end
    
    
    end

end

