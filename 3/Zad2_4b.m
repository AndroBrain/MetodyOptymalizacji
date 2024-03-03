clc;
clear;
close all;

file = load("Data01.mat");
t = file.t;
y = file.y;
N = size(y,1);
M = N - 1;
D = zeros(M, N);
for i = 1:M-1
    D(i, i) = 1;
    D(i+1, i) = -1;
end

% parametr
p = 1.5;

% Prawie jak 20 przekształcone na 23 bez warunku 20c
A = [
    eye(N) -eye(N) zeros(N, M);
    -eye(N) -eye(N) zeros(N, M);
    -D zeros(M, N) -eye(M);
    D zeros(M, N) -eye(M);
];
b = [
    y;
    -y;
    zeros(M, 1);
    zeros(M, 1);
];
% Prawie jak 20 przekształcone na 23 z dodatkiem uwzględniającym p
c = [zeros(1, N), ones(1, N), zeros(1, M)] + p * [zeros(1, N), zeros(1, N), ones(1, M)];
% https://www.mathworks.com/help/optim/ug/linprog.html
v = linprog(c, A, b);

plot(t, y, '.g')
hold on;
plot(t, v(1:N), 'r')