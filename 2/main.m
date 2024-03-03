clc;
clear;
close all;

file = load("isoPerimData.mat");

C = file.C;
F = file.F;
L = file.L;
N = file.N;
a = file.a;
y_fixed = file.y_fixed;
h = a/N;

f_a = minimize_f_a(N, L, C, F, h, y_fixed);
f_b = minimize_f_b(N, L, C, F, h, y_fixed);
f_c = maximize_f_c(N, L, C, F, h, y_fixed);

% Wzór nr. 8
fprintf('a) minimize = %f \n', h * sum(f_a(:, 1)));
fprintf('b) minimize = %f \n', h * sum(f_b(:, 1)));
fprintf('c) maximize = %f \n', h * sum(f_c(:, 1)));

% Wykresy
x = linspace(0, a, N + 1);

plots = 3;
subplot(1,plots,1);
draw_plot(x, f_a, F, y_fixed, 'a)')
subplot(1,plots,2);
draw_plot(x, f_b, F, y_fixed, 'b)')
subplot(1,plots,3);
draw_plot(x, f_c, F, y_fixed, 'c)')

function draw_plot(x, f, F, y_fixed, title)
    % Linia
    plot(x, f(:, 1));
    hold on;
    grid on;
    xlabel('x/a');
    ylabel('y(x)');
    % Punkty
    plot(x(F), y_fixed(F), '.');
end

function f = minimize_f_a(N, L, C, F, h, y_fixed)
    cvx_begin quiet
        variable f(N + 1, 1);
        % 16a
        minimize( h * sum(f) );
        
        subject to
            % Wzór nr. 11
            length = 0;
            for i = 1:N
                length = length + norm([h; f(i + 1) - f(i)]);
            end
            length <= L;
            % Wzór nr. 15
            abs((f(3:end) - 2 * f(2:end-1) + f(1:end-2)) / h^2) <= C;
            % 16d
            f(1) == 0;
            % 16e
            f(N + 1) == 0;
            % 16f
            f(F) == y_fixed(F);
    cvx_end
end

function f = minimize_f_b(N, L, C, F, h, y_fixed)
    cvx_begin quiet
        variable f(N + 1, 1);

        % 16a
        minimize( h * sum(f) );
        
        subject to
            % Wzór nr. 11
            length = 0;
            for i = 1:N
                length = length + norm([h; f(i + 1) - f(i)]);
            end
            length <= L;
            % Wzór nr. 15
            abs((f(3:end) - 2 * f(2:end-1) + f(1:end-2)) / h^2) <= C;
            % 16d
            f(1) == 0;
            % 16e
            f(N + 1) == 0;
            % 16f
            f(F) == y_fixed(F);
            % !!! Wymaganie z zadania
            f >= 0
    cvx_end
end

function f = maximize_f_c(N, L, C, F, h, y_fixed)
    cvx_begin quiet
        variable f(N + 1, 1);
        % !!! Maksymalizacja zamiast minimalizacji
        % 16a
        maximize( h * sum(f) );
        
        subject to
            % Wzór nr. 11
            length = 0;
            for i = 1:N
                length = length + norm([h; f(i + 1) - f(i)]);
            end
            length <= L;
            % !!! Brak ograniczenia na krzywą
            % 16d
            f(1) == 0;
            % 16e
            f(N + 1) == 0;
            % 16f
            f(F) == y_fixed(F);
    cvx_end
end
