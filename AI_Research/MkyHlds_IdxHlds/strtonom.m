% For all dataset variables in the workspace
% convert dataset type string columns to type nominal


tmpVarNames = who';

for tmp_j = 1:length(tmpVarNames)

    if isa(eval(tmpVarNames{tmp_j}),'dataset')

        tmpFieldNames = eval(strcat(tmpVarNames{tmp_j},'.Properties.VarNames'));

        for tmp_i = 1:length(tmpFieldNames)
            
            if isa(eval(strcat(tmpVarNames{tmp_j},'{1,tmp_i}')),'char')
                
                try 
                    tmp_fmt = 'yyyy-mm-dd';
                    tmp_dt = datenum(eval(strcat(tmpVarNames{tmp_j},'{1,tmp_i}')),tmp_fmt);
                    
                    tmpAuxStr = strcat(tmpVarNames{tmp_j}, '(:,',num2str(tmp_i),') = mat2dataset(datenum(',tmpVarNames{tmp_j}, '.',tmpFieldNames{1,tmp_i},'))',char(59));
                    eval(tmpAuxStr);
                    
                    
                catch
                    
                    tmpAuxStr = strcat(tmpVarNames{tmp_j}, '.',tmpFieldNames{1,tmp_i},' = ',' nominal(',tmpVarNames{tmp_j}, '.',tmpFieldNames{1,tmp_i},')',char(59));
                    eval(tmpAuxStr);
                
                end

            end

        end


    end

end

clear tmpVarNames
clear tmpFieldNames
clear tmpAuxStr
clear tmp_i
clear tmp_j
clear tmp_fmt
clear tmp_dt

    

    



