clc;
clear;
close all;

f = @(s) 20 * s.^2 - 44 * s + 29;
fr = @(s) 40 * s - 44;

% prędkość
b = 0.1;

draw_plot(f, fr, b, 0.3);