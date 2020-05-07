function [attrib] = attrib_equity_decomp(idx_w,idx_r,port_w,port_r,agg_idx_r)            
            
    if  isa(idx_w,'dataset'), idx_w = double(idx_w); end
    if  isa(idx_r,'dataset'), idx_r = double(idx_r); end
    if  isa(port_w,'dataset'), port_w = double(port_w); end
    if  isa(port_r,'dataset'), port_r = double(port_r); end
    if  isa(agg_idx_r,'dataset'), agg_idx_r = double(agg_idx_r); end
    
    
    [m, n] = size(idx_r);
    
    agg_idx_r = repmat(agg_idx_r,m,1);
    idx_w = repmat(idx_w,1,n);
    port_w = repmat(port_w,1,n);
    
    ni_sec = (port_w-idx_w).*(idx_r-agg_idx_r);
    ni_iss = (port_r-idx_r).*port_w;
    attrib = mat2dataset([ni_iss ni_sec]);
    attrib.Properties.ObsNames={};
    
    
