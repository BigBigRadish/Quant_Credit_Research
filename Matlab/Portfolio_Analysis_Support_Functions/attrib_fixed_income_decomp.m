function [Port_rtn_decomp] = attrib_fixed_income_decomp(Port_ds,spr_chg_bench)            
            
            inc_rtn = Port_ds.cur_cpn./Port_ds.price/12;
            inc_rtn(isnan(inc_rtn))=0;
            tsy_rtn = ((1+Port_ds.tot_rtn/100)./(1+Port_ds.excess_rtn/100)-1)*100;
            tsy_rtn(isnan(tsy_rtn))=0;
            spr_rtn = ((1+Port_ds.tot_rtn/100)./((1+tsy_rtn/100).*(1+inc_rtn/100))-1)*100;
            spr_rtn(isnan(spr_rtn))=0;
            
            spr_chg = spr_rtn./(-1*Port_ds.spr_dur);
            spr_chg(isnan(spr_chg))=0;
            select_rtn = zeros(size(Port_ds,1),1);
            
            if ~isempty(spr_chg_bench)
                spr_chg = spr_chg_bench;
                aux_spr_rtn = spr_rtn;
                spr_rtn = -1*Port_ds.spr_dur.*spr_chg_bench;
                select_rtn = (((1+aux_spr_rtn/100)./(1+spr_rtn/100))-1)*100;
                select_rtn(isnan(select_rtn))=0;
            end
            
            Port_ds = horzcat(Port_ds,mat2dataset([inc_rtn tsy_rtn spr_rtn select_rtn spr_chg]));
            Port_ds.Properties.VarNames(end-4:end) = {'inc_rtn','tsy_rtn','spr_rtn','select_rtn','spr_chg'};
            Port_rtn_decomp = Port_ds;
           
            
end