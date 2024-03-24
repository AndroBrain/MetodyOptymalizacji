clc;
clear;
close all;

% paramtery
k_max = 8;
X = zeros(k_max, 2);
u = ones(k_max, 1);
u(1) = 1;
z = zeros(k_max, 1);
z(1) = 0;
OR = zeros(k_max, 1);
FR = zeros(k_max, 1);

% 42a
f = @(x) [
    x(1) + exp(-x(2)); 
    x(1)^2 + 2*x(2) + 1
];
% 42b
g = @(x) x(1) + x(1)^3 + x(2) + x(2)^2;

df = @(x) [1 + 2*x(1), -exp(-x(2)); 0, 2];
dg = @(x) [1 + 3*x(1)^2, 1 + 2*x(2)];

% ustalanie algorytmu jako Lavenberg
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt');

X(1,:) = [0.5; -0.5];
for i = 1:k_max
    % 37
    min_function = @(x) norm([f(x); sqrt(u(i)) * g(x) + (1/(2 * sqrt(u(i)))) * z(i)])^2;
    % rozwiązanie
    estimates = lsqnonlin(min_function, X(i, :), [], [], options);
    
    % 33
    z(i + 1) = z(i) + 2 * u(i) * g(estimates);

    min_function = @(x) norm([f(x); sqrt(u(i)) * g(x) + (1/(2 * sqrt(u(i)))) * z(i+1)])^2;
    % jeszcze raz z nowym Xem
    estimates = lsqnonlin(min_function, estimates, [], [], options);
    X(i + 1, :) = estimates;
    OR(i, :) = log10(norm(2*transpose(df(estimates))*f(estimates) + transpose(dg(estimates))*z(i+1)));
    FR(i, :) = log10(norm(g(X(i,:))));
    
    if ( norm(g(X(i + 1,:))) < 0.25 * norm(g(X(i, :))) ) 
        u(i + 1) = u(i);
    else
        u(i + 1) = 2 * u(i);
    end
end
X
z
table(FR, OR)

figure(1)
x1_values = linspace(-1, 1, 100);
x2_values = linspace(-1, 1, 100);
[X1, X2] = meshgrid(x1_values, x2_values);
Z = arrayfun(@(x1,x2)norm([x1+exp(-x2);x1^2+2*x2+1],2),X1,X2);
Z2 = arrayfun(@(x1,x2) (x1+x1^3+x2+x2^2), X1, X2);
contour(X1,X2,Z, 'ShowText', 'on');
hold on;
grid on;
contour(X1,X2,Z2,[0,2],'ShowText', 'on');
plot(X(:,1), X(:,2), 'bo');
