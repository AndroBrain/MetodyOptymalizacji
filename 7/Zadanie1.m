% Newton's Method for optimization

% Define the optimization function with its variables
f = @(x) exp(x(1)) + 3*x(2)^2 - 0.1 + exp(-x(1)) - 0.1 + (x - [1;1])' * [sqrt(7), 3; 3, 5] * (x - [1;1]);
% Define the gradient of the function
grad_f = @(x) [exp(x(1)) - exp(-x(1)) + 2*(sqrt(7)*(x(1)-1) + 3*(x(2)-1)); 6*x(2) + 2*(3*(x(1)-1) + 5*(x(2)-1))];
% Define the Hessian matrix of the function
hess_f = @(x) [exp(x(1)) + exp(-x(1)) + 2*sqrt(7), 6; 6, 12];

% Initialization
x0 = [2; -2]; % Initial guess for the solution
N = 100; 
tol = 1e-4; 
iteration_points = zeros(2, N);
breaking_point = N;
x = x0; 
for k = 1:N 
    g = grad_f(x); 
    H = hess_f(x); 
    
    % Newton update rule: x_new = x - inv(H)*g
    x_new = x - H\g; 
    iteration_points(:, k) = x;
    if norm(x_new - x) < tol
        breaking_point = k;
        break;
    end
    
    x = x_new; 
end

x_optimal = x; 

figure;
x1_values = linspace(min(x(1,:))-1, max(x(1,:))+1, 100);
x2_values = linspace(min(x(2,:))-1, max(x(2,:))+1, 100);
[X1, X2] = meshgrid(x1_values, x2_values);

% Evaluate the function on the grid
Z = arrayfun(@(x1, x2) f([x1; x2]), X1, X2);

% Generate the contour plot
contour(X1, X2, Z, 50); 
hold on;

% Plot the iterative points
plot(iteration_points(1,10:2:end), iteration_points(2,10:2:end), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('x_1');
ylabel('x_2');
title('Contour Plot with Iterative Points of Newton''s Method');
hold off;






% Newton's Method with Damping (Backtracking Line Search)
alpha = 0.5; 
beta = 0.5; 
t = 1;  %Using t in place of s
iteration_points_2 = zeros(2, N);
breaking_point_2 = N;

x = x0; 
for k = 1:N 
    g = grad_f(x); 
    H = hess_f(x); 
    v = -H\g; 
    f0 = f(x); 
    
    % Backtracking line search to find the step size t
    while f(x + t*v) > f0 + alpha*t*g'*v % Check the Armijo condition
        t = beta*t;
    end
    
    x_new = x + t*v; % Update x with the found step size
    iteration_points_2(:, k) = x;
    % If the change in x is less than the tolerance, stop the iteration
    if norm(x_new - x) < tol
        breaking_point_2 = k;
        break;
    end
    
    x = x_new; % Update x for the next iteration
end

x_optimal_damped = x; % The optimal solution found by Newton's method with damping

figure;
% Define the grid for contour plot
x1_values = linspace(min(x(1,:))-1, max(x(1,:))+1, 100);
x2_values = linspace(min(x(2,:))-1, max(x(2,:))+1, 100);
[X1, X2] = meshgrid(x1_values, x2_values);

% Evaluate the function on the grid
Z = arrayfun(@(x1, x2) f([x1; x2]), X1, X2);

% Generate the contour plot
contour(X1, X2, Z, 50);
hold on;

% Plot the iterative points
plot(iteration_points(1,10:2:end), iteration_points(2,10:2:end), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('x_1');
ylabel('x_2');
title('Contour Plot with Iterative Points of Newton''s Method part two');
hold off;



