clc;
clear all;

tic

lb     = [-1000, -1000, -1000, 0];
ub     = [1000, 1000, 1000, 100];
theta0 = [0, 0, 0, 1];
opt    = optimset('TolFun',1E-10,'TolX',1E-10,'MaxFunEvals',...
         1000, 'Algorithm', 'sqp');

DataIn = dlmread('C:\Users\Haritz\Desktop\Haritz Git\Matlab_book\auto.csv');
y      = DataIn(:,1);
x      = DataIn(:, 2:3);
x      = [x, ones(74,1)];

[theta, minusloglik, exitflag] = fmincon(@(theta)NormalML(theta,y,x), theta0,...
        [], [], [], [], lb, ub, [], opt)
    
toc

% Time that it takes: 0.845 with opt, 0.78 without. 4.267 with the graph of
% the convergence and the likelihoods displayed. 3.95 with the high ub and
% lb.
