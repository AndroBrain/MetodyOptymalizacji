clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;
N = size(y,1);

% parametr
q = 1.2;

v = optimvar('v', N, 1);
E = optimvar('E', N, 1);
Q = optimvar('Q', N - 1, 1);

p = optimproblem('ObjectiveSense', 'min');
% 20a
p.Objective = ones(1, N) * E;
% 20b
p.Constraints.c1 = y - v <= E;
p.Constraints.c2 = y - v >= -E;
% 20c
p.Constraints.c3 = ones(1, N - 1) * Q <= q;
% 20d
p.Constraints.c4 = v(2:end) - v(1:end-1) <= Q;
p.Constraints.c5 = v(2:end) - v(1:end-1) >= -Q;
options = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'OptimalityTolerance', 1e-10);
sol = solve(p, 'Options', options);

plot(t, y, '.')
hold on;
plot(t, sol.v, 'r')