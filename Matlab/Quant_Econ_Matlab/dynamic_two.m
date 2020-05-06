clc;
clear all;

tic 

Beta  = 0.9;
T     = 10;
K1    = 100;
Alpha = 0.98;
Theta = 1.2;
lb    = zeros(10, 2);
ub    = 100*ones(10,2);
guess = [10*ones(10, 1), [90:-10:0]'];
opt   = optimset('TolFun', 1E-10, 'TolX', 1E-10, 'algorithm', 'sqp',...
        'MaxFunEvals', 100000, 'MaxIter', 2000);
result = fmincon(@(CK) FlowUtility(T, Beta, CK), guess, [], [], [], [],...
        lb, ub, @(CK) FlowConstraint(CK, T, K1, Theta, Alpha), opt)
    
plot(1:T, result(:, 1), '--r', 1:T, result(:, 2), 'linewidth', 2)
xlabel('Time', 'FontSize', 14)
ylabel('C_t, k_t', 'FontSize', 14)
legend('Consumption', 'Capital Remaining', 'Location', 'NorthEast')
title({'Firm Consumption and Investment', '\beta=0.9, \theta=1.2, \alpha=0.98'},...
        'FontSize', 16)

toc