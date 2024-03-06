% Define constants and initial parameters
epsilon = 1e-4;
alpha = 0.5;
beta = 0.8;
t = 0.1;
x_c = [1; 1]; 
P = [1, 0; 0, 1];

% Function definition
f = @(x) t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) ...
    - log(1 - (x - x_c)' * P * (x - x_c));

% Gradient definition (as provided in the task)
grad_f = @(x) t * ([exp(x(1) + 3*x(2) - 0.1) - exp(-x(1) - 0.1); 3*exp(x(1) + 3*x(2) - 0.1)]) ...
    + 2 * P * (x - x_c) / (1 - (x - x_c)' * P * (x - x_c));

% Hessian definition (as provided in the task)
hess_f = @(x) t * ([exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1), 3*exp(x(1) + 3*x(2) - 0.1); ...
                     3*exp(x(1) + 3*x(2) - 0.1), 9*exp(x(1) + 3*x(2) - 0.1)]) ...
    + 4 * P * (x - x_c) * (x - x_c)' * P / (1 - (x - x_c)' * P * (x - x_c))^2 ...
    + 2 * P / (1 - (x - x_c)' * P * (x - x_c));

% Initial point
x0 = x_c; 

% Newton's method with damping
x = x0;
for k = 1:100
    % Compute gradient and Hessian
    g = grad_f(x);
    H = hess_f(x);
    
    % Check for non-positive values within log argument to avoid complex numbers
    if any(1 - (x - x_c)' * P * (x - x_c) <= 0)
        disp('The argument of the log function must be positive.');
        break;
    end
    
    % Update step
    dx = -H\g;
    
    % Backtracking line search
    while f(x + t*dx) > f(x) + alpha*t*g'*dx || any(1 - (x + t*dx - x_c)' * P * (x + t*dx - x_c) <= 0)
        t = beta*t;
    end
    
    % Update x
    x = x + t*dx;
    
    % Check for convergence
    if norm(dx) < epsilon
        break;
    end
end

% Display results
disp(['Optimal point: ', mat2str(x)]);




% Define the function to be minimized for fminsearch
fmin_func = @(x) t * (exp(x(1) + 3*x(2) - 0.1) + exp(-x(1) - 0.1)) ...
  - log(1 - (x - x_c)' * P * (x - x_c));



% fminsearch
options = optimset('Display', 'iter', 'TolX', epsilon);
[x_fmin, fval] = fminsearch(fmin_func, x0, options);

% Display the results
disp(['fminsearch Optimal point: ', mat2str(x_fmin)]);


% CVX Version
cvx_begin
variable x_cvx(2)
minimize( t * (exp(x_cvx(1) + 3*x_cvx(2) - 0.1) + exp(-x_cvx(1) - 0.1)) ...
  - log(1 - (x_cvx - x_c)' * P * (x_cvx - x_c)) );
% Include any constraints here
cvx_end

% Display the results
disp(['CVX Optimal point: ', mat2str(x_cvx)]);
