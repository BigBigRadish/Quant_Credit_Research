clc;
clear all;

tic

DataIn    = dlmread('auto.csv');
X         = [ones(74,1) DataIn(:,2:3)];
y         = DataIn(:,1);
opt       = optimset('TolFun',1E-10,'TolX',1E-10,'MaxFunEvals',...
            1000);
[Beta, Q, ex, out] = fminsearch(@(B) GMMObjective(B,y,X),...
            [10, 0, 0]', opt)
        
toc