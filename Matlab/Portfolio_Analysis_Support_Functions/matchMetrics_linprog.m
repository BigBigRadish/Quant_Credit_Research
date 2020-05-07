% function [f_vec] = matchMetrics_linprog(OrigPortConstituentBins,idx_include,...
%                             categories,metrics, ...
%                             OrigPort_bin_weights,binNames)
    clear;
    load('test_linprog.mat');    
	%catnumVar = size(categories,2);
    metnumVar = size(metrics,2);                        

    
    
    beq_ds = grpstats(OrigPortConstituentBins,binNames,{@sum},'DataVars',{'mkt_weight'});
    beq_ds.Properties.ObsNames = {};
    
    r = size(beq_ds,1);
    num_rows = size(OrigPortConstituentBins,1);
    [bin_vecU] = get_dsColNum(beq_ds.Properties.VarNames,binNames);
    
    %[cat_vecOrig] = get_dsColNum(OrigPortConstituentBins.Properties.VarNames,categories);
    [met_vecOrig] = get_dsColNum(OrigPortConstituentBins.Properties.VarNames,binNames);

    A = zeros(r,num_rows);
    
	for i = 1:r
        
        ix = ones(num_rows,1)*double(beq_ds(i,bin_vecU));
        ix = ix==double(OrigPortConstituentBins(:,met_vecOrig));
        ix = sum(ix,2);
        ix = ix==metnumVar;

        A(i,:) = ix';
        
     
	end
    
    %A(end,:) = idx_include';
    
    %b = [b+1;-b+min(b)];
%     biter = [b_pos;b_neg];
    
%     non_zero_columns = idx_include;
%     Aeq = ones(1,sum(non_zero_columns));
%     beq = 100;
%     lb = zeros(sum(non_zero_columns),1);
%     ub = ones(sum(non_zero_columns),1);
%     % eliminate empty columns
%     % Aiter = A(:,non_zero_columns);
%     % eliminate empty rows
%     % As = sum(Aiter,2);
%     non_zero_rows = find(sum(A(:,non_zero_columns),2)~=0);
% %     Aiter = Aiter(aux,:);
% %     biter = biter(aux,:);
%     f = H0A0Ana.ytw(non_zero_rows);
%     f = -1*f;
%     [x, fval] = linprog(f,...
%                         A(non_zero_rows,non_zero_columns),...
%                         biter(non_zero_rows,1),...
%                         Aeq,beq,lb,ub);
    
    A = [A;-A];
    non_zero_columns = idx_include;
    w = 0;
    %non_zero_columns(x<w,1)=0;
    b = beq_ds.sum_mkt_weight;
    b_pos = b;
    b_neg = -b;
    biter = [b_pos*1.1;b_neg*0.90];
    beq = 100;
    
    while (sum(non_zero_columns)>150) && w<0.25 && (b_pos(1)<1.4*b(1))
        
        Aeq = ones(1,sum(non_zero_columns));
        %beq = 100;
        lb = w*ones(sum(non_zero_columns),1);
        ub = ones(sum(non_zero_columns),1);
        % eliminate empty columns
        % Aiter = A(:,non_zero_columns);
        % eliminate empty rows
        [non_zero_rows] = find(sum(A(:,non_zero_columns),2)~=0);
%         Aiter = Aiter(aux,:);
%         biter = biter(aux,:);
        f = H0A0Ana.ytw(non_zero_columns);
        f = -1*f;
        exitflag=0;
        while exitflag~=1
            [x, fval,exitflag] = linprog(f,...
                                        A(non_zero_rows,non_zero_columns),...
                                        biter(non_zero_rows,1),...
                                        Aeq,beq,lb,ub);
            b_pos = b_pos*1.05;
            b_neg = b_neg*0.95;
            biter = [b_pos;b_neg];
            %biter = biter(aux,:);
        end
        
        w = prctile(x,25);
        non_zero_columns(x<w,1)=0;


        
    end
        
    %x(x<0.25) = 0;
    
    f_vec = zeros(size(idx2,1),1);
    f_vec(idx_include,1)=x;
    
    
    
%end    