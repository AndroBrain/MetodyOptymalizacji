function s = get_step(f, fr, a, b)
    s = 1;
    while f(s) >= f(0) + a * fr(0) * s
        s = s * b;
    end
end