clc;
clear;

tic

%---- (1) Setup parameters
e    = [-2 2];
PI   = [0.5 0.5];
Beta = 0.9;   Theta = 1.2;  Alpha = 0.65;
K1   = 100;
grid = 0.1;
T    = 10;

K    = 0:grid:(K1+max(e));
V    = [NaN(length(K), T), zeros(length(K), 1)];
aux  = NaN(length(K), length(K), T);

people  =  100;

epsilon = randi(2,people,T+1);
% people                = 100;
% epsilon               = randi(2,people,T+1);
epsilon(epsilon == 1) = -2;

toc