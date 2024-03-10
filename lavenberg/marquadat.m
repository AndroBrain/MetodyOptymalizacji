function xOptimal = marquadat(n, k_max,)
    X = zeros(n,k_max+1);
    X(:,1) = x0;
    L = 1.0;
    for k = 1:k_max
        x = X(:,k);
        xNew = x - inv(transpose(J(x)) * J(x) + L * eye(n)) * transpose(J(x)) * f(x);
        if ( norm(f(xNew)) < norm(f(x0)) )
            X(:,k+1) = xNew;
            L = 0.8*L;
        else
            X(:,k+1) = x;
            L = 2*L;
        end
    end
    xOptimal = X(:,end);
end