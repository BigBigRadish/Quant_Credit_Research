function [risk_val] = credit_risk_metric_OneGroup(auxAnaDS,auxFinDS)



        %% Determine financial metrics highly correlated to analytics
        AnaAggFin = horzcat(auxAnaDS,auxFinDS(:,22:77));

        % Determine financial metrics highly correlated to analytics
        % Filter 'AnaAggFin' dataset using             
        X = AnaAggFin(:,[7:8,16,18:39,41:44]);
        X = double(X);
        Y = AnaAggFin(:,47:102);
        Y = double(Y);
        Y(isnan(Y)) = 0;


        [RHO,PVAL] = corr(X,Y);
        RHOds = mat2dataset(RHO);
        RHOds.Properties.VarNames = AnaAggFin.Properties.VarNames(47:102);
        RHOds.Properties.ObsNames = AnaAggFin.Properties.VarNames([7:8,16,18:39,41:44]);

        PVALds = mat2dataset(PVAL);
        PVALds.Properties.VarNames = AnaAggFin.Properties.VarNames(47:102);
        PVALds.Properties.ObsNames = AnaAggFin.Properties.VarNames([7:8,16,18:39,41:44]);


        %% Rank issuers based on financial metrics
        metrics_vec = [1 3 6 21 38]; % Net Debt, TotAssets, IntCov, TotLev, SrDbtPct
        % metrics_vec1 = [44 52 67];
        % metrics_vec5 = [28 34 44 52 67];


        % NaN's are assigned the highest rankings.
        % Sort is done in ascending order.
        aux_AAFin = double(AnaAggFin(:,47:102));
        
        [~, sort_idx] = sort(aux_AAFin,1);
        [r, c] = size(sort_idx);
        num = zeros(r,c);
        for i = 1:c
            num(sort_idx(:,i),i) = 1:r;
        end    
        nan_idx = isnan(aux_AAFin);
        num_nans = sum(nan_idx);

        num_sign = sign(RHO(19,:)); % RHO row 19 corresponds to OAS
        % sign of correlation is currently being forced to a particular value.
        num_sign(:,metrics_vec) = [1,-1,-1,1,1];
        num_sign(isnan(num_sign))=0;
        num_nans = ones(r,1)*num_nans;
        num = num+num_nans;
        num(nan_idx) = 1;

        aux = zeros(1,56);
        aux(1,metrics_vec) = num_sign(1,metrics_vec);
        risk_val = num*aux';

%         [~, sort_rsk] = sort(risk_val);
%         risk_val(sort_rsk,1)= 1:size(risk_val)';

%         col_vec = getdsCol(aux_FinDS.Properties.VarNames,{'ticker','companyId'});
%         risk_val = horzcat(aux_FinDS(:,col_vec),risk_val);
%         risk_val.Properties.VarNames(end) = {'risk_val')




end

