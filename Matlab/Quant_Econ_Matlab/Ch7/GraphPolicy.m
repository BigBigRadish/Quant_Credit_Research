tic

%--- (1) Setup parameters, pre-fill matrices
cmap = cool(7);
V    = zeros(1000, 1);
grid = 1000;
K    = linspace(1e-6, 100, grid);
aB   = 0.65*0.9; Theta = 1.2; Alpha = 0.65;

%--- (2) Plot analytical solution to determine performance
plot(K, aB*Theta*K.^Alpha, '-k', 'LineWidth', 3)
hold all

%--- (3) Iterate using Howard Algorithm, plot each step
for l= 1:7
    [V,k] = IteratePolicy(V,100);
    plot(K, K(k), 'color', cmap(l, :))
end

legend('Analytical', 'Iter1', 'Iter2', 'Iter3', 'Iter4', 'Iter5',...
      'Iter6', 'Iter7', 'Location', 'NorthWest')
xlabel('Amount of Capital')
ylabel('Optimal k_{t+1}')
title('Policy Function Iteration and Consumption')

%---- (1) Start the simulation

K1   = 100;
T    = 10;
people = 1000;
epsilon = randi(2,people,T);
epsilon(epsilon == 1) = -2;

kapit       = zeros(people, T);
consum      = zeros(people, T);
kapit(:, 1) = K1;


for t= 1:T
    for j= 1:people
    position      = round(kapit(j, t)/grid +1);
    kapit(j, t+1) = K(position);
    consum(j, t)  = Theta*(kapit(j, t).^Alpha) - kapit(j, t+1);
    kapit(j, t+1) = kapit(j, t+1) + epsilon(j, t);
    
    end
end
    
%--- (3) Output
figure(2)
plot([1:1:T], consum)
ylabel('Consumption', 'FontSize', 12)
xlabel('Time', 'FontSize', 12)
title('Simulated Consumption Paths', 'FontSize', 16)

figure(3)
hist(sum(consum, 2))
title('Lifetime Consumption', 'FontSize', 16)



toc