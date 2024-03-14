function [x_optimal, breaking_point, iteration_points] = newton_method_with_backtracking(grad_f, hess_f, f, x_initial, N, tol, alpha, beta, step)
    x = x_initial;
    iteration_points = zeros(length(x_initial), N);
    t = step;
    for k = 1:N 
        g = grad_f(x); 
        H = hess_f(x); 
        v = -H\g; 
        f0 = f(x); 
        
        % Rozpoczęcie z arbitralną wartością 

        % Backtracking line search
        while f(x + t*v) > f0 + alpha*t*g'*v % Sprawdzanie warunku Armijo
            t = beta*t;
        end

        x_new = x + t*v; % Aktualizacja x z uwzględnieniem znalezionej wartości t
        iteration_points(:, k) = x;
        
        % Jeśli zmiana w x jest mniejsza niż tolerancja, zakończ iterację
        if norm(x_new - x) < tol
            breaking_point = k;
            break;
        end

        x = x_new; % Aktualizacja x na kolejną iterację
    end

    x_optimal = x; 
end
