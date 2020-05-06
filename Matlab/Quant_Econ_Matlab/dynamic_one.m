clc;
clear all;

tic 

beta  = linspace(0.99, 0.2, 5)';
T     = 10;
K1    = 100;
lb    = eps*ones(10, 1);
ub    = 100*ones(10,1);
guess = 10*ones(10, 1);
A     = ones(1, 10);
opt   = optimset('TolFun', 1E-20, 'TolX', 1E-20, 'algorithm', 'sqp',...
         'MaxFunEvals', 100000, 'MaxIter', 2000);
con   = zeros(T, length(beta));

for i = 1:length(beta)
    
Beta      = beta(i, 1);    
con(:, i) = fmincon(@(C) FlowUtility(T, Beta, C), guess, A, K1, [], [],...
            lb, ub, [], opt);
   
end

plot(1:T, con(:, 1), '--r', 1:T, con(:, 2), 'linewidth',...
      1:T, con(:, 3), '--y', 1:T, con(:, 4), 'marker',...
      1:T, con(:, 5), '--c', 5)
xlabel('Time', 'FontSize', 14)
ylabel('C_t', 'FontSize', 14)
legend('\Beta=', '\Beta=')
title({'Firm Consumption for different discount factors'},...
        'FontSize', 16)


toc