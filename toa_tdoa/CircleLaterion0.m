clearvars; clc; close all;

%% # circles
xc = [-4 -1 9]; yc = [16 0 9]; r = [20 12 10];
for s = 1:length(xc)
   circle(xc(s),yc(s),r(s)); 
end

%% Subtract two equation which gives line
x = xlim; x = x(1):x(2);

y = ((r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2) ...
    - ((-2*xc(1) + 2*xc(2))*x))  / ... 
    ((-2*yc(1) + 2*yc(2)));

%% Plot circles and line
hold on;
plot(x,y)

%% HelperFunctions
function [h,xcor,ycor] = circle(x,y,rad,ss)
if ~exist('ss','var')
    ss = 50;
end
if ~exist('rad','var')
    rad = 3;
end
hold on
p = 0:pi/ss:2*pi;
xcor = rad * cos(p) + x;
ycor = rad * sin(p) + y;
h = plot(xcor, ycor);
hold off
end