clearvars; clc; close all; 
h=figure('WindowState','maximized');
hold on;

%% # circles
xc = [-4 -15 15];
yc = [20 -10 0]; 
r = [25 20 15];
combinations = nchoosek(1:length(xc),2)';
cols = colormap("hsv");
colsidx = round(linspace(1,length(cols)-50,length(combinations)));
cols = cols(colsidx,:);
colcnt = 1;
thick = linspace(6,2,length(combinations)); %vector with line thicknesses bases on #circles

for nCb = combinations 
    currcol = cols(colcnt,:);
    h_cir = drawcircle(xc(nCb(1)),yc(nCb(1)),r(nCb(1)),currcol,thick(colcnt));
    h_cir = drawcircle(xc(nCb(2)),yc(nCb(2)),r(nCb(2)),currcol,thick(colcnt));
    colcnt = colcnt + 1;
end
axis equal; set(h,'Visible','on')
plot(1,-1,'k+','Linewidth',3,'MarkerSize',18);
hold off;


% pause(1)
% saveTightFigure(gcf,'trilaterion_matlab.png')


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