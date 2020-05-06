clc;
clear all;

tic

DataIn = dlmread('C:\Users\Haritz\Desktop\Haritz Git\Matlab_book\auto.csv');
y      = DataIn(:,1);
x      = DataIn(:, 2:3);
x      = [x, ones(74,1)];


lb     = [-100, -100, -100];
ub     = [100, 100, 100];
theta0 = [0, 0, 1];

options=optimset('MaxFunEvals', 1000, 'MaxIter', 1000,'TolX',1e-12,'TolFun',1e-12, 'Display', 'off' );

a=ProbitML(theta0,y,x)

% opt    = optimset('TolFun',1E-10,'TolX',1E-10,'MaxFunEvals',...
%         10000, 'Algorithm', 'sqp');
     
% opt    = optimset ('Display','iter','TolX',1e-15,'TolFun',1e-15,'MaxIter',20000,'MaxFunEvals',1000000);

[theta, minusloglik, exitflag] = fmincon(@(theta)ProbitML(theta,y,x), theta0,...
       [], [], [], [], lb, ub, [], options)
       
toc