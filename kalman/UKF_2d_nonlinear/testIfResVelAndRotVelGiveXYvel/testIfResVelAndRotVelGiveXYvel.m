function testIfResVelAndRotVelGiveXYvel()
close all; clear variables; clc;
[a] = UKF_create_simulation_data(true);

[ap.thisFile, nm.CurrFile] = fileparts(mfilename('fullpath'));
cd(ap.thisFile);
load(fullfile(fileparts(ap.thisFile),'UKF_create_simulation_data.mat'))

figure('units','normalized','outerposition',[0.1 0.1 0.9 0.9]); nsp = 1;
subplot(3,3,nsp); nsp = nsp + 1;
plot(clean.velocity.res,'DisplayName','clean resultant velocity');
grid on; grid minor; title('Resultant velocity');

subplot(3,3,nsp); nsp = nsp + 1;
plot(clean.velocity.angularRate,'DisplayName','clean angular velocity');
grid on; grid minor; title('Angular velocity');

subplot(3,3,nsp); nsp = nsp + 1;
plot(clean.velocity.x,'DisplayName','velocity x','Color','g');
grid on; grid minor; title('Desired velocity x');

subplot(3,3,nsp); nsp = nsp + 1;
plot(clean.velocity.y,'DisplayName','velocity y','Color','r');
grid on; grid minor; title('Desired velocity y');

subplot(3,3,nsp); nsp = nsp + 1;
angularRate = clean.velocity.angularRate;
plot(angularRate,'DisplayName','angular Rate','Color','m');
plot(clean.velocity.angularRate,'DisplayName','Clean angles between points','Color','g');
grid on; grid minor; title('angular Rate');

subplot(3,3,nsp); nsp = nsp + 1;
startAngle = atan2d((position.x2(2)-position.x2(1)),(position.y2(2)-position.y2(1)));
Angles = clean.velocity.angles + startAngle;
plot(Angles,'DisplayName','Angle','Color','m');
grid on; grid minor; title('Angles');

subplot(3,3,nsp); nsp = nsp + 1;
V = clean.velocity.res;
velx = V.*cosd(Angles);
plot(velx,'DisplayName','velocity x','Color','g');
grid on; grid minor; title('Attempt to get velocity x');

subplot(3,3,nsp); nsp = nsp + 1;
vely = V.*sind(Angles);
plot(vely,'DisplayName','velocity y','Color','r');
grid on; grid minor; title('Attempt to get velocity y');

subplot(3,3,nsp); nsp = nsp + 1;
plot(position.x2,position.y2);
grid on; grid minor; title('x y'); hold on;
plot(cumtrapz(velx)/temporalspecs.fs2,cumtrapz(vely)/temporalspecs.fs2,'m');
axis equal
end

