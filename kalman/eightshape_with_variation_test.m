function [x,y] = eightshape_test()
close all;
dt = 0.01;
t = 0:dt:20;

maxX = 4500;
maxY = 10000;
[x,y] = eightshape_with_variation(t,maxX,maxY);

subplot(3,1,1);
plot(x,y); grid on; grid minor; axis equal;
subplot(3,1,2);
plot(t,x); grid on; grid minor;
subplot(3,1,3);
plot(t,y); grid on; grid minor;
end

