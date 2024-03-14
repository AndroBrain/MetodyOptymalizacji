p = 1/8*[7, sqrt(3);sqrt(3), 5];
xc = [1;1];
x0 = [2;-2];
epsilon = 1e-4;
alpha = 0.5;
beta = 0.5;
f = @(x) exp(x(1)+3*x(2)-0.1)+exp(-x(1)-0.1)+(x-xc)'*p*(x-xc);
grad_f = @(x) [exp(x(1)+3*x(2)-0.1)-exp(-x(1)-0.1); 3*exp(x(1)+ 3*x(2)-0.1)] + 2*p*(x-[1;1]);
g = @(x, y) grad_f(x) - grad_f(y);
hess_f = @(x) [exp(x(1)+3*x(2)-0.1), 3*exp(x(1)+3*x(2)-0.1); 3*exp(x(1)+3*x(2)-0.1), 9*exp(x(1)+3*x(2)-0.1)] + 2*p;

N = 100;

I = [1,0;0,1];

H = I;
x = x0;
s = 1;
for k = 1:N
    grad = grad_f(x); 
    h = hess_f(x); 
    v = -h\grad; 
    f0 = f(x);

    while f(x + s*v) > f0 + alpha*s*grad'*v % Check the Armijo condition
       s = beta*s;
    end

    x_new = x - s*H*grad_f(x);
    
    del_x = x_new - x;
    if norm(x_new - x) < epsilon
        break_point = k;
        break;
    end
    del_x = x_new - x;
    %nowy krok

    % Poprawka rzędu jeden
    H_new = H + ((del_x - H*g(x_new, x))*(del_x - H*g(x_new, x))')/((del_x - H*g(x_new, x))'*g(x_new, x));

    % Poprawka Davidona-Fletchera-Powella DFP
    % H_new = H + (del_x*del_x')/(g(x_new, x)'*del_x) - (H*g(x_new, x)*((H*g(x_new,x))'))/(g(x_new, x)'*H*g(x_new,x));

    %Poprawka Broydena-Fletchera-Goldfarba-Shanno (BFGS) wersja z
    %instrukcji
    % H_new = H - (H*g(x_new, x)*((H*g(x_new,x))'))/(g(x_new, x)'*H*g(x_new, x)) ...
    %     - (g(x_new, x)'*del_x*g(x_new, x)*(H*g(x_new,x))')/(g(x_new,x)'*H*g(x_new,x)*(g(x_new,x)'*H*g(x_new, x))) ...
    %     + (H*g(x_new, x)*x' + (H*g(x_new, x)*x')')/(g(x_new,x)'*H*g(x_new,x));

    %poprawka Broydena-Fletchera-Goldfarba-Shanno (BFGS) wersja z innych źródeł
    % H_new = (I-(del_x*g(x_new,x)')/(g(x_new,x)'*del_x))*H*(I-(g(x_new, x)*del_x')/(g(x_new,x)'*del_x)) + (del_x*del_x')/(g(x_new,x)'*del_x);
    H = H_new;
    x = x_new;
end
disp(x)