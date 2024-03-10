close all
clear all
clc


load("LM04Data")
k_max = 25;
a = 2;
h = @(x,t) x(1)*exp(-t * a).*sin(x(2)*t+x(3));
f = @(x) x(1) *exp(-t * a).*sin(x(2)*t+x(3))-y;

x0 = [1, 7*pi, 0]; % initial values of model parameters
n = length(x0);


J = @(x) [sin(x(2)*t+x(3)) x(1)*t.*cos(x(2)*t+x(3)) x(1)*cos(x(2)*t+x(3))];

% Lavenberg-Matquardt Algorithm
X = zeros(n,k_max+1);
figure
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
    plot(k,L,"s","MarkerEdgeColor","black","MarkerFaceColor","black");
    hold on;
    plot(k,norm(f(xNew)),"s","MarkerEdgeColor","r","MarkerFaceColor","r");
    hold on;
end
xOptimal = X(:,end)

nfontslatex = 18;
nfonts = 14;

figure
plot01 = plot(t,y,"s","MarkerEdgeColor","r","MarkerFaceColor","r");
hold on
tPlot = linspace(t(1),t(end),1e+3);
plot02 = plot(tPlot,h(x0,tPlot),"b","LineWidth",2);
hold on
plot03 = plot(tPlot,h(xOptimal,tPlot),"k","LineWidth",2);

legend([plot01,plot02,plot03],"measurement", "first guess", "final fit")
grid on
set(gca,"FontSize",nfonts);
ylabel("$y = A\sin(\omega t + \phi)$ [a.u.]","Interpreter","Latex","FontSize",nfontslatex)
xlabel("$t$ [s]","Interpreter","Latex","FontSize",nfontslatex)

figure
set(gca,"FontSize",nfonts);
subplot(3,1,1)
plot((0:k_max),X(1,:),"k","LineWidth",2)
ylabel("$A$ [a.u.]","Interpreter","Latex","FontSize",nfontslatex)
subplot(3,1,2)
plot((0:k_max),X(2,:),"k","LineWidth",2)
ylabel("$\omega$ [rad/s]","Interpreter","Latex","FontSize",nfontslatex)
subplot(3,1,3)
plot((0:k_max),X(3,:),"k","LineWidth",2)
ylabel("$\varphi$ [rad]","Interpreter","Latex","FontSize",nfontslatex)
xlabel("iteration number","Interpreter","Latex","FontSize",nfontslatex)