tic

M  = csvread('C:/Users/Haritz/Desktop/Haritz Git/Rust problem set/ddc_pset-2.csv', 1, 0);
i  = M(:, 1);
t  = M(:, 2);
a  = M(:, 3);
x  = M(:, 4);
RC = M(:, 5);

% Normalize RC

NT = size(M, 1);

% 100 thousand observations. 1000 buses, 100 periods.

tPeriods      = 100;
nBuses        = 1000;
tolFixedPoint = 1e-10;

iRC     = reshape(RC, [tPeriods, nBuses]);
iX      = reshape(x, [tPeriods, nBuses]);
choices = reshape(a, [tPeriods, nBuses]);
% t  = reshape(t, [tPeriods, nBuses]);
% i  = reshape(i, [tPeriods, nBuses]);

nSuppX    = 7;
supportX  = (1:nSuppX)';
supportRC = (31.5:0.5:62.5)';
nSuppRC   = size(supportRC, 1);
beta      = 0.95;
thetaone  = 1; % Nomrmalization
thetainit = 2;

capPi               = estimatePiR(iRC,nSuppRC);
capPi(isnan(capPi)) = 0 ;

% objF = @(theta)negLogLikR(choices,iX,supportX,iRC,supportRC,capPi,beta,thetaone,theta,...
                                          % @flowpay,@bellmanR,@fixedPointR,tolFixedPoint)
objF = negLogLikR(choices,iX,supportX,iRC,supportRC,capPi,beta,thetaone,thetainit,...
@flowpay,@bellmanR,@fixedPointR,tolFixedPoint)
                                       
startvalues = 1;
lowerBounds = -Inf*ones(size(startvalues));

OptimizerOptions = optimset('Display','iter','Algorithm','interior-point','AlwaysHonorConstraints','bounds',...
                            'GradObj','on','TolFun',1E-6,'TolX',1E-10,'DerivativeCheck','off','TypicalX',thetainit);
maxLikEs = fmincon(objF,startvalues,[],[],[],[],lowerBounds,[],[],OptimizerOptions)

disp('Summary of Results');
disp('--------------------------------------------');
disp([theta(2) startvalues maxLikEs]);


toc