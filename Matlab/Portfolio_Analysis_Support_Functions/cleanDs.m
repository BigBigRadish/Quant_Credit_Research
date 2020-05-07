function [cleanF] = cleanDs(auxF,col_vec)
%% Clean Financial dataset table
% Replace NaN with zeros in fields where a NaN has occurred when
% likely value is zero in real life, and not where a NaN
% has occurred because value is undefined or not collected (as
% in the case of issuers with a financial template for which
% leverage and interest coverage are not calculated).
% In particular we are replacing NaN's for all debt ammount
% metrics, EBITDA margin, and Net Rental Expense

    % replace NaN in capex, int_expense, ebitda margin,
    % net rental expense and debt ammount columns with zeros.
    nD = ismissing(auxF);
    x = double(auxF(:,col_vec));
    x(nD(:,col_vec))=0;
    auxF(:,col_vec) = mat2dataset(x);
    cleanF = auxF;

end