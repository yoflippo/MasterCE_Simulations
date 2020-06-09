clearvars; clc; close all; 
h=figure;
hold on;

%% # circles
xc = [-4 -15 5];
yc = [20 -10 9]; 
r = [25 20 15];
combinations = nchoosek(1:length(xc),2)';
thick = linspace(6,2,length(combinations)); %vector with line thicknesses bases on #circles

for nCb = combinations % binomial coeff combinations
    h_cir = drawcircle(xc(nCb(1)),yc(nCb(1)),r(nCb(1)),[0.5 0.5 0.5]);
    h_cir = drawcircle(xc(nCb(2)),yc(nCb(2)),r(nCb(2)),[0.5 0.5 0.5]);
    intersectionLineCircle(xc(nCb),yc(nCb),r(nCb),'r',h_cir)
end
axis equal; set(h,'Visible','on');
grid on; grid minor;
xlabel('x-coordinates'); ylabel('y-coordinates');
title('TOA')


MatrixMiddle(xc,yc,r)
hold off;
pause(1)
set(gca,'XColor','none'); set(gca,'YColor','none')
export_fig(gcf,[mfilename '.png'],'-transparent','-r300');
%saveTightFigure(gcf,'trilaterion_matlab.png')

%% Helper functions
function intersectionLineCircle(xc,yc,r,color,h)
% Subtract two equation which gives line
x = xlim; x = linspace(x(1),x(2),2);
y = ((r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2) - ((-2*xc(1) + 2*xc(2))*x))  / ((-2*yc(1) + 2*yc(2)));

if ~exist('color','var')
    plot(x, y,'Linewidth',1);
else
    plot(x, y,'r','Linewidth',3,'MarkerSize',20);
end
end

function MatrixMiddle(xc,yc,r)
A = [(-2*yc(1) + 2*yc(2)) (-2*xc(1) + 2*xc(2)) 1;
     (-2*yc(1) + 2*yc(3)) (-2*xc(1) + 2*xc(3)) 1;
     (-2*yc(3) + 2*yc(2)) (-2*xc(3) + 2*xc(2)) 1;];

b = [r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2 ...
     r(1)^2 - r(3)^2 - xc(1)^2 + xc(3)^2 - yc(1)^2 + yc(3)^2 ...
     r(3)^2 - r(2)^2 - xc(3)^2 + xc(2)^2 - yc(3)^2 + yc(2)^2]';

y = A\b;
plot(y(2),y(1),'k+','Linewidth',3,'MarkerSize',18);
end
