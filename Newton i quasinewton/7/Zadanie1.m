% Newton's Method for optimization

p = 1/8*[7, sqrt(3);sqrt(3), 5];

% Define the optimization function with its variables
f = @(x) exp(x(1)+3*x(2)-0.1)+exp(-x(1)-0.1)+(x-[1;1])'*p*(x-[1;1]);
% Define the gradient of the function
grad_f = @(x) [exp(x(1)+3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+ 3*x(2)-0.1)] + 2*p*(x-[1;1]);
% Define the Hessian matrix of the function/
hess_f = @(x) [exp(x(1)+3*x(2)-0.1), 3*exp(x(1)+3*x(2)-0.1); 3*exp(x(1)+3*x(2)-0.1), 9*exp(x(1)+3*x(2)-0.1)] + 2*p;


% Initialization
x0 = [2; -2]; % Initial guess for the solution
N = 100; 
tol = 1e-4; 

[x_optimal, breaking_point, iteration_points] = newton_method(grad_f, hess_f, x0, N, tol);


figure;
x1_values = linspace(-3.5, 2.5, 100);
x2_values = linspace(-2.25, 2.25, 100);
[X1, X2] = meshgrid(x1_values, x2_values);

% Evaluate the function on the grid
Z = arrayfun(@(x1, x2) f([x1; x2]), X1, X2);

levels = [600, 200, 50, 19.2, 7.59, 5.34, 3.62, 2.47];

% Generate the contour plot
contour(X1, X2, Z, levels); 
hold on;

% Plot the iterative points
plot(iteration_points(1,1:breaking_point), iteration_points(2,1:breaking_point), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('x_1');
ylabel('x_2');
title('Contour Plot with Iterative Points of Newton''s Method');
hold off;






% Newton's Method with Backtracking Line Search
alpha = 0.5; 
beta = 0.5; 
step = 1;  %Using t in place of s

[x_optimal_damped, breaking_point_2, iteration_points_2] = newton_method_with_backtracking(grad_f, hess_f, f, x0, N, tol, alpha, beta, step);

figure;
% Define the grid for contour plot
x1_values = linspace(-3.5, 2.5, 100);
x2_values = linspace(-2.25, 2.25, 100);
[X1, X2] = meshgrid(x1_values, x2_values);

% Evaluate the function on the grid
Z = arrayfun(@(x1, x2) f([x1; x2]), X1, X2);

% Generate the contour plot
contour(X1, X2, Z, levels);
hold on;

% Plot the iterative points
plot(iteration_points_2(1,1:breaking_point_2), iteration_points_2(2,1:breaking_point_2), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('x_1');
ylabel('x_2');
title('Contour Plot with Iterative Points of Newton''s Method with backtracking');
hold off;



[x_optimal_fun, breaking_point_fun, iteration_points_fun] = newton_method(grad_f, hess_f, x0, N, tol);


