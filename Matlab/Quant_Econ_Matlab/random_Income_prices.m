clc;
clear all;

tic

%--- (1) Simulation of optimal consumption with random income
% and good 1 prices (negatively correlated)

% Random variation in income and price 1

I       = 10000;  % Income
P       = [50, 200];
reps    = 100;
mu      = [0, 0];
sigma   = [10, -4;-4, 10];
rng default
r       = mvnrnd(mu, sigma, reps); % r is a reps times 2 matrix
I_shock = [r(:, 1)];
II      = I_shock + I;
P_shock = [r(:, 2), zeros(reps, 1)];

%----- (2) Determine optimal consumption for each
% value of the prices -----------------------------------

x0     = [1, 1];
lb     = [0, 0];
opts   = optimset('algorithm', 'sqp', 'display', 'off');

c      = zeros(reps, 2);

for i = 1:reps
    TempI   = I_shock(i, 1) + I;
    TempP   = P_shock(i, :) + P;
    ub      = TempI./TempP;
    c(i, :) = fmincon(@UtilityChTwo, [1, 1], TempP, TempI, [], [], ...
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
ylabel('F(c_1)')

scatter(c(:, 1), II)


toc