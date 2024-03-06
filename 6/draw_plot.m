function draw_plot(f, fr, b, a_to_draw)
    x = linspace(0, 2.5);
    y = @(s, a) f(0) + s * a * fr(0);
    plot(x, f(x), 'black');
    hold on;
    for a = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 1.0]
        plot(x, y(x, a), 'blue');
        hold on;
        if a == a_to_draw
            s = get_step(f, fr, a, b)
            plot(s, f(s), 'o');
            hold on;
            plot(s, y(s, a), 'o');
            hold on;
        end
    end
    grid on;
    ylim([-30 50]);
    xlabel('s');
    ylabel('f(s), y(s)');
end