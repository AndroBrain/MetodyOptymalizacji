clc;
clear;
close all;

% paramtery
k_max = 50;
X = zeros(1, 3);
u = ones(1, 1);
u(1) = 1;
OR = zeros(1, 1);
FR = zeros(1, 1);

% 42a
f = @(x) (x(1) - 1)^2 + (x(2) - 1)^2 + (x(3) - 1)^2;
% 42b
g = @(x) [
    x(1)^2 + 0.5*x(2)^2 + x(3)^2 - 1;
    0.8*x(1)^2 + 2.5*x(2)^2 + x(3)^2 + 2*x(1)*x(3) - x(1) - x(2) - x(3) - 1
];

df = @(x) [2*(x(1) - 1), 2*(x(2)-1), 2*(x(3)-1)];
dg = @(x) [
    2*x(1), x(2), 2*x(3);
    1.6*x(1) + 2*x(3) - 1, 5*x(2) - 1, 2*x(3) + 2*x(1) - 1
];

% ustalanie algorytmu jako Lavenberg
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt');

X(1,:) = [0; 0; 0];
for i = 1:k_max
    penalty_function = @(x) [
        f(x);
        sqrt(u(i)) * g(x)
    ];
    estimates = lsqnonlin(penalty_function, X(i, :), [], [], options);

    X(i + 1, :) = estimates;
    tempor = 2*transpose(df(estimates))*f(estimates) + transpose(dg(estimates));
    OR(i, :) = norm(tempor);
    FR(i, :) = norm(g(X(i,:)));

    if tempor < 10e-5
        if g(estimates) < 10e-5
            break
        end
    end
    
    if ( norm(g(X(i + 1,:))) < 0.25 * norm(g(X(i, :))) ) 
        u(i + 1) = u(i);
    else
        u(i + 1) = 2 * u(i);
    end
end
X(end, :)

% Plot results
figure;
subplot(3,1,1);
semilogy(FR);
title('FR vs k');
xlabel('k');
ylabel('FR');

subplot(3,1,2);
semilogy(OR);
title('OR vs k');
xlabel('k');
ylabel('OR');

subplot(3,1,3);
semilogy(u);
title('\mu vs k');
xlabel('k');
ylabel('\mu');

