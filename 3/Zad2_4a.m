clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;
N = size(y,1);
M = N - 1;

% parametr
parameter = 12;

v = optimvar('v', N, 1);
E = optimvar('E', N, 1);
Q = optimvar('Q', M, 1);

p = optimproblem('ObjectiveSense', 'min');
% 28a
p.Objective = ones(1, N) * E + parameter * ones(1, M) * Q;
% 28b
p.Constraints.c1 = y - v <= E;
p.Constraints.c2 = y - v >= -E;
% 28d
p.Constraints.c4 = v(2:end) - v(1:end-1) <= Q;
p.Constraints.c5 = v(2:end) - v(1:end-1) >= -Q;
options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
sol = solve(p, 'Options', options);

plot(t, y, '.')
hold on;
plot(t, sol.v, 'r')