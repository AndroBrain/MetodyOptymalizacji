clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;
N = size(y);

% rozwiązanie zadania 4 w ramach zad 1

% parametr
p = 1.5;

cvx_begin quiet 
    variable v(N)

    % 4
    minimize(norm(y - v, 2) + p * norm(v(2:end) - v(1:end-1), 1));
cvx_end

% pomiary
plot(t, y, '.');
hold on;
% sygnał
plot(t, v, 'r');