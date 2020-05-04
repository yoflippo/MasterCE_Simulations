clearvars; clc; close all; 
h=figure('WindowState','maximized');
hold on;

%% # circles
xc = [-4 -15 20];
yc = [20 -10 12]; 
m1 = 0; m2 = m1;
plot(m1,m2,'k^','Linewidth',3,'MarkerSize',18)

r = [dis(xc(1),yc(1),m1,m2) dis(xc(2),yc(2),m1,m2) dis(xc(3),yc(3),m1,m2)];
combinations = nchoosek(1:length(xc),2)';
% find some color
cols = colormap("hsv");
colsidx = round(linspace(1,length(cols)-50,length(combinations)));
cols = cols(colsidx,:);

global colcnt; colcnt = 1;
thick = linspace(6,2,length(combinations)); %vector with line thicknesses bases on #circles

for nCb = combinations % binomial coeff combinations
    currcol = cols(colcnt,:);
    h_cir = drawcircle(xc(nCb(1)),yc(nCb(1)),r(nCb(1)),currcol,thick(colcnt));
    h_cir = drawcircle(xc(nCb(2)),yc(nCb(2)),r(nCb(2)),currcol,thick(colcnt));
    intersectionLineCircle(xc(nCb),yc(nCb),r(nCb),currcol,h_cir)
    colcnt = colcnt + 1;
end
axis equal; set(h,'Visible','on')
grid on; grid minor;
MatrixMiddle(xc,yc,r)
hold off;
pause(1)
%saveTightFigure(gcf,'trilaterion_matlab.png')

%% END SCRIPT, Begin HelperFunctions


function intersectionLineCircle(xc,yc,r,color,h)
% Subtract two equation which gives line
x = xlim; x = linspace(x(1),x(2),length(h.XData));
y = ((r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2) - ((-2*xc(1) + 2*xc(2))*x))  / ((-2*yc(1) + 2*yc(2)));

if ~exist('color','var')
    plot(x, y,'Linewidth',1);
else
    plot(x, y,'Color',color,'Linewidth',2,'LineStyle',':');
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


%% End Helperfunctions












% [17:39, 1/16/2020] Herre Faber: Het optimale punt is nu het punt waarvan de loodrechte afstand tot lijn 1 plus de loodrechte afstand naar lijn 2 plus de loodrechte afstand naar lijn 3 minimaal is.
% [17:39, 1/16/2020] Herre Faber: En dat is een lineair probleem.
% [17:40, 1/16/2020] Herre Faber: 3 vergelijkingen 2 onbekenden
% [17:40, 1/16/2020] Herre Faber: In matrixvorm schrijven
% [17:41, 1/16/2020] Herre Faber: A*x=b
% [17:44, 1/16/2020] Herre Faber: Oplossing (AT*A)^-1)*AT*b
% [17:44, 1/16/2020] Herre Faber: AT is A getransponeerd
% [17:44, 1/16/2020] Herre Faber: Dakje min 1 is inverse van
% [17:46, 1/16/2020] Herre Faber: Met bollen krijg je volgens mij bij 3 zenders 3 vgl met 3 onbekenden en hoef je bovenstaande formule niet te gebruiken
% [17:46, 1/16/2020] Herre Faber: Wel weer als je 4 zenders gaat gebruiken
% [17:48, 1/16/2020] Herre Faber: In matlab kan je x=A\b doen en dan doet hij onderwater die formule
% [17:48, 1/16/2020] Herre Faber: Ben benieuwd hoe  ver je komt en of het idd werkt