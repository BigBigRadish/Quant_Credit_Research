tic

%--- Convergence to the Value Function
conv = 100;
crit = 1e-2;

K    = linspace(1e-6, 100, 1000);
V    = zeros(1000, 1);
axis([0 100 -15 10])
hold on

cc   = hot(70);
Iter = 0;

while conv>crit
    Iter      = Iter + 1
    [TV optK] = IterateVF(V, 100);
    conv      = max(abs(TV - V))
    plot(K, TV, 'color', cc(Iter, :))
    V         = TV;
end

% Plot the optimal k tomorrow given k today, both the mapping found by 
% value function iteration, and the analytical one

aB = 0.65*0.9; Theta = 1.2; Alpha = 0.65;
plot(K, K(optK), K, aB*Theta*K.^Alpha, '--r', 'LineWidth', 3)
xlabel('Amount of Capital', 'FontSize', 12)
ylabel('Optimal k_{t+1}', 'FontSize', 12)
title('Policy Function: K Consumption', 'FontSize', 14)

% Do the same, but with consumption

Ctrue = (1 - aB)*Theta*K.^Alpha;
Cval  = Theta*(K.^Alpha) - K(optK);
plot(K, Cval, K, Ctrue, '--g', 'LineWidth', 3)
xlabel('Amount of Capital', 'FontSize', 12)
ylabel('Optimal c(k)', 'FontSize', 12)
title('Policy Function: Consumption', 'FontSize', 14)

toc