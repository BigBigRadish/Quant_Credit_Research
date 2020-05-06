clc;
clear all;

tic

%--- (1) Simulation of optimal consumption with random prices

% Random variation in prices

P      = [50, 200];
reps   = 100;
pshock = [rand(reps, 1) * 50, zeros(reps, 1)];

I      = 10000;  % Income

%----- (2) Determine optimal consumption for each
% value of the prices -----------------------------------

x0     = [1, 1];
lb     = [0, 0];
opts   = optimset('algorithm', 'sqp', 'display', 'off');

c      = zeros(reps, 2);

for i = 1:reps
    TempP   = P + pshock(i, :);
    ub      = I./TempP;
    c(i, :) = fmincon(@UtilityChTwo, [1, 1], TempP, I, [], [], ...
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