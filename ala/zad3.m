clc;
clear;
close all;

n = 60;
m = n;
A = randn(m, n);
b = randn(m, 1);
k_max = 10;
X = zeros(1, 3);
u = ones(1, 1);
z = zeros(1, 2);

f = @(x, A, b) A * x - b;
g = @(x) x.^2 - 1;
objective = @(x, A, b) norm(A*x - b)^2; 

% ustalanie algorytmu jako Lavenberg
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt');

x = A \ b;
z = zeros(n, 1);
objectives = [];
for i = 1:k_max
    min_function = @(x) norm([
        f(x, A, b);
        sqrt(u(i)) * g(x) + (1/(2 * sqrt(u(i)))) * z
    ])^2;
    previous_x = x;
    x = lsqnonlin(min_function, x, [], [], options);

    feasible_x = sign(x);
    z = z + 2 * u(i) * g(feasible_x);
    % Przypisywanie kolejnych wartości
    objectives(end + 1) = objective(feasible_x, A, b);

    if ( norm(g(x)) < 0.25 * norm(g(previous_x)) ) 
        u(i + 1) = u(i);
    else
        u(i + 1) = 2 * u(i);
    end
end
objectives
figure;
plot(objectives);
xlabel('k');
ylabel('objectives');
title('Objetive vs k');