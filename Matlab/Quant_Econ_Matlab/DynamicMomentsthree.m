function Q=DynamicMomentsthree(ct, ctp, kt, ktp, params, W)
%------------
% PURPOSE: returns quadratic distance based on dynamic model 
% moments and specified values of alpha and theta
%------------
% INPUTS: ct     : Nx(T-1) matrix of C_t,     t = 1,...,9
%         ctp    : Nx(T-1) matrix of C_{t+1}, t = 1,...,9
%         kt     : Nx(T-1) matrix of K_t,     t = 1,...,9
%         ktp    : Nx(T-1) matrix of K_{t+1}, t = 1,...,9
%         params : [Alpha: Theta]
%------------
% OUTPUT: Q: value of moment conditions
%------------

Alpha  = params(1);
Theta  = params(2);
Beta   = 0.9;
k      = size(params, 2)*size(ct, 2);

%--- (1) Form moments
m1   = mean([ ktp - Theta.*(kt - ct).^Alpha], 1); % Take the mean over columns
m2   = mean([(ctp./( Beta.*ct )) - Alpha.*Theta.*...
        (kt - ct).^(Alpha - 1)], 1);

Q   = [m1 m2]*W*[m1 m2]';
    
end