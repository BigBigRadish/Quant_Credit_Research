function [summary_rtn, attrib] = attrib_equity_decomp(idx_w,idx_r,port_w,port_r)            
            
    H_rtn = sum(idx_r.*idx_w)/sum(idx_w);
    F_rtn = sum(port_r.*port_w)/sum(port_w);


    summary_rtn = mat2dataset([H_rtn F_rtn]);
    summary_rtn.Properties.VarNames = {'H_rtn','F_rtn'};

    ni_sec = (port_w-idx_w).*(idx_r-sum(idx_w))/100;
    ni_iss = (port_r-idx_r).*port_w/100;
    attrib = mat2dataset([ni_iss ni_sec]);
    attrib.Properties.VarNames(end-1:end)={'net_iss','net_sec'};
    attrib.Properties.ObsNames={};