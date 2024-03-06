clc;
clear;
close all;

f = @(s) 40 * s.^3 + 20 * s.^2 - 44 * s + 29;
fr = @(s) 120 * s.^2 + 40 * s - 44;

% prędkość
b = 0.9;

draw_plot(f, fr, b, 0.4);