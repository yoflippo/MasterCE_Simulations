close all;
clearvars;
clc
syms x y x1 y1 x2 y2 d;

%% Example data
x1 = 3; y1 = 2;
x2 = -3; y2 = -4;
m1 = -1; m2 = 9;
% Distance between TAG and ANC's
R1 = sqrt((x1-m1)^2 + (y1-m2)^2);
R2 = sqrt((x2-m1)^2 + (y2-m2)^2);
d = abs(R2-R1)

%% Equation
f = (sqrt((x1-x)^2 + (y1-y)^2) - (sqrt((x2-x)^2 + (y2-y)^2))) == d;
xa = solve(f,x);

%% Plotting
fplot(xa,'Color','k')
hold on
plot(x1,y1,'Marker','+','Color','r',   'MarkerSize',20,'LineWidth',2)
plot(x2,y2,'Marker','+','Color','b',   'MarkerSize',20,'LineWidth',2)
plot(m1,m2,'Marker','.','Color','k',   'MarkerSize',20,'LineWidth',2)
grid on; grid minor;
axis([-10 10 -10 10])
