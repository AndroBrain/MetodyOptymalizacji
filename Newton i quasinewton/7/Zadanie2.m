% Define constants and initial parameters
epsilon = 1e-4;
alpha = 0.5;
beta = 0.8;
t = 0.1;
x_c = [1; 1]; 
P = [1, 0; 0, 1];

% Define the optimization function with its variables
f = @(x) exp(x(1)+3*x(2)-0.1)+exp(-x(1)-0.1)+(x-[1;1])'/8*[7, sqrt(3);sqrt(3), 5]*(x-[1;1]);
% Define the gradient of the function
grad_f = @(x) [exp(x(1)+3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+ 3*x(2)-0.1)] + 2*p*(x-[1;1]);
% Define the Hessian matrix of the function/
hess_f = @(x) [exp(x(1)+3*x(2)-0.1), 3*exp(x(1)+3*x(2)-0.1); 3*exp(x(1)+3*x(2)-0.1), 9*exp(x(1)+3*x(2)-0.1)] + 2*p;

% Initial point
x0 = x_c; 

% Newton's method with damping
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
    if norm(x_new - x) < epsilon
        breaking_point_2 = k;
        break;
    end

    x = x_new; % Update x for the next iteration
end

newton_optimal = x;
% Display results
disp(['Optimal point: ', mat2str(newton_optimal)]);




% fminsearch
options = optimset('Display', 'iter', 'TolX', epsilon);
[x_fmin, fval] = fminsearch(f, x0, options);

% Display the results
disp(['fminsearch Optimal point: ', mat2str(x_fmin)]);


% CVX Version
cvx_begin
variable x_cvx(2)
minimize( exp(x_cvx(1)+3*x_cvx(2)-0.1)+exp(-x_cvx(1)-0.1)+(x_cvx-[1;1])'/8*[7, sqrt(3);sqrt(3), 5]*(x_cvx-[1;1]) );
% Include any constraints here
cvx_end

% Display the results
disp(['CVX Optimal point: ', mat2str(x_cvx)]);
