clc;
clear all;

tic

alpha = 12;
beta  = (linspace(5, 9, 21))';

A     = [2, 1;3, 2];
b     = [1000; 1600];
lb    = zeros(2,1);

fi  = zeros(length(beta), 2);
val = zeros(length(beta), 1);
ex  = zeros(length(beta), 1);

for i = 1:length(beta)
    Beta = beta(i, 1);
    f    = [-alpha; -Beta];

    [fi(i, :), val(i, 1), ex(i, 1)] = linprog(f, A, b, [], [], lb);

end

fi
val
ex


toc