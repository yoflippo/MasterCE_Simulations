function eightshape_with_variation_test()
close all; clc
dt = 0.01;
t = 0:dt:20;

maxX = 4500;
maxY = 10000;
[x,y] = eightshape_with_variation(t,maxX,maxY);

subplot(3,1,1);
plot(x,y); grid on; grid minor; %axis equal;
subplot(3,1,2);
plot(t,x); grid on; grid minor;
subplot(3,1,3);
plot(t,y); grid on; grid minor;

figure
velocity.x = gradient(x,dt);
velocity.y = gradient(y,dt);
acceleration.x = gradient(velocity.x,dt);
acceleration.y = gradient(velocity.y,dt);
subplot(3,1,1);
plot(t,x,'DisplayName','x');  grid on; grid minor; hold on;
plot(t,y,'DisplayName','y'); 
subplot(3,1,2);
plot(t,velocity.x,'DisplayName','velx');  grid on; grid minor; hold on;
plot(t,velocity.y,'DisplayName','vely'); 
subplot(3,1,3);
plot(t,acceleration.x,'DisplayName','velx');  grid on; grid minor; hold on;
plot(t,acceleration.y,'DisplayName','vely'); 
covar = cov([x; y; velocity.x; velocity.y; acceleration.x; acceleration.y]')
end

