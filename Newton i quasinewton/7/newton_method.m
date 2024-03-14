function [x_optimal, breaking_point, iteration_points] = newton_method(grad_f, hess_f, x_initial, N, tol)
    x = x_initial;
    iteration_points = zeros(length(x_initial), N);
    
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
end
