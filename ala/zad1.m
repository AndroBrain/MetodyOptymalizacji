clc;
clear;
close all;

% paramtery
k_max = 10;
X = zeros(k_max, 2);
u = ones(k_max, 1);
u(1) = 1;
z = zeros(k_max, 1);
z(1) = 1;
x_start = [0.5; -0.5];
OR = zeros(k_max, 1);
FR = zeros(k_max, 1);

% 42a
f = @(x) [
    x(1) + exp(-x(2)); 
    x(1)^2 + 2*x(2) + 1
];
% 42b
g = @(x) x(1) + x(1)^3 + x(2) + x(2)^2;
% ustalanie algorytmu jako Lavenberg
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt');

X(1,:) = [0.5; -0.5];
for i = 1:k_max
    % 37
    min_function = @(x) norm([f(x); sqrt(u(i)) * g(x) + (1/(2 * sqrt(u(i)))) * z(i)])^2;
    % rozwiązanie
    [estimates, resnorm, residual, exitflag, output] = lsqnonlin(min_function, x_start, [], [], options);
    
    X(i + 1, :) = estimates;
    FR(i, :) = log10(g(X(i,:)));
    % 33
    z(i + 1) = z(i) + 2 * u(i) * g(estimates);
    if ( norm(g(X(i + 1,:))) < 0.25 * norm(g(X(i, :))) ) 
        u(i + 1) = u(i);
    else
        u(i + 1) = 2 * u(i);
    end
end
X
z
FR

function [c, ceq] = ncon(x)
    ceq = x(1) + x(1)^3 + x(2) + x(2)^2;
    c = [];
end