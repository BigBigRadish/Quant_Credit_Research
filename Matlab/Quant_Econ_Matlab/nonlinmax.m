clc;
clear all;

I  = 100;
P  = [4, 7];
G  = [15, 5];
lb = [0, 0]; 

opts = optimset('algorithm', 'sqp');

[consumption, u, exitflag] = ...
    fmincon(@UtilityChTwo, G, P, I, [],...
    [], lb, [], [], opts)