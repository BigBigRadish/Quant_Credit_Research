clc;
clear all;

f = [-143; -60];
A = [1, 1;110, 30;120, 210];
b=[75; 4000; 15000];
lb=zeros(2,1);

[crops, obj, exitflag] = linprog(f, A, b, [], [], lb)