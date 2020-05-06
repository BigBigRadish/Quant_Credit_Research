cd('C:\Users\Haritz\Desktop\Haritz Git\Matlab_book')

FiniteStochastic;
SimulStoch;

opt = optimset('TolFun', 1E-20, 'TolX', 1E-20);

kt   = kap(:, 1:9);
ct   = con(:, 1:9);
ctp  = con(:, 2:10);
ktp  = kap(:, 2:10);

[Param, Q] = fminunc(@(p) DynamicMomentstwo...
             (ct, ctp, kt,...
               ktp, p), [1, 1], opt)
           
alphahat = Param(1)
thetahat = Param(2)
 
mm1   = [ ktp - thetahat.*(kt - ct).^alphahat]; % Take the mean over columns
mm2   = [(ctp./( Beta.*ct )) - alphahat.*thetahat.*...
        (kt - ct).^(alphahat - 1)];
    
covarmoments = ([mm1 mm2]'*[mm1 mm2])./people;
bu = size (covarmoments)
weighttwo    = inv(covarmoments);

[Par, Q] = fminunc(@(pp) DynamicMomentsthree...
             (ct, ctp, kt,...
               ktp, pp, weighttwo), [1, 0.9], opt)

% This last two step GMM estimation allows us to obtain estimates of 
% alpha and beta that are closer to the true parameters.