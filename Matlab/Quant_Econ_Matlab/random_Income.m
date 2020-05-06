clc;
clear all;

tic

%--- (1) Simulation of optimal consumption with random income

% Random variation in income

I      = 10000;  % Income
P      = [50, 200];
reps   = 100;
I_shock = [randn(reps, 1)*100 + I];

%----- (2) Determine optimal consumption for each
% value of the prices -----------------------------------

x0     = [1, 1];
lb     = [0, 0];
opts   = optimset('algorithm', 'sqp', 'display', 'off');

c      = zeros(reps, 2);

for i = 1:reps
    TempI   = I_shock(i, 1);
    ub      = TempI./P;
    c(i, :) = fmincon(@UtilityChTwo, [1, 1], P, TempI, [], [], ...
        lb, ub, [], opts);
        
end

%-------- (3) Visualize results -------------------------

subplot(1,2,1)
scatter(c(:, 1), c(:,2),'filled')
xlabel('Good 1 Consumption')
ylabel('Good 2 Consumption')
ylim([20 30])

subplot(1,2,2)
cdfplot(c(:, 1))
xlabel('Good 1 Consumption')
ylabel('F(p_1)')


toc