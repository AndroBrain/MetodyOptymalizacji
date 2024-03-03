clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;
N = size(y);

% parametr
q = 1.2;

cvx_begin quiet 
    variable v(N)

    % 3a
    minimize(norm(y - v, 2));
    % 3b
    subject to
        % podpowiedź zad. 1
        norm(v(2:end) - v(1:end-1), 1) <= q;
cvx_end

% pomiary
plot(t, y, '.');
hold on;
% sygnał
plot(t, v, 'r');




