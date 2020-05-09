clearvars; clc; close all; h=figure('WindowState','maximized');

%% # circles
xc = [-4 -1 9]; yc = [16 0 9]; r = [20 12 10];
cols = ["r:"; "g:"; "b:";]; global colcnt; colcnt = 1;
thick = linspace(6,1,length(xc));

for nCb = nchoosek(1:length(xc),2)' % binomial coeff combinations
    h_cir = circle(xc(nCb(1)),yc(nCb(1)),r(nCb(1)),cols(colcnt),thick(colcnt));
    h_cir = circle(xc(nCb(2)),yc(nCb(2)),r(nCb(2)),cols(colcnt),thick(colcnt));
    intersectionLineCircle(xc(nCb),yc(nCb),r(nCb),cols(colcnt),h_cir)
    colcnt = colcnt + 1;
end
axis equal; set(h,'Visible','on')
grid on



%% HelperFunctions
function h = circle(x,y,rad,color,lineth)
if not(exist('rad','var'))
    rad = 3;
end
if not(exist('lineth','var'))
    lw = 1;
else
    lw = lineth;
end

p = 0:pi/100:2*pi;
xcor = rad * cos(p) + x;
ycor = rad * sin(p) + y;

hold on
if not(exist('color','var'))
    h = plot(xcor, ycor,'Linewidth',lw);
    plot(x,y,'+','Linewidth',lw,'MarkerSize',13);
else
    tmpcolor = char(color);
    h = plot(xcor, ycor,tmpcolor(1),'Linewidth',lw);
    plot(x,y,[tmpcolor(1) '+'],'Linewidth',lw,'MarkerSize',13);
end
hold off
end

function intersectionLineCircle(xc,yc,r,color,h)
%% Subtract two equation which gives line
x = xlim; x = linspace(x(1),x(2),length(h.XData));
y = ((r(1)^2 - r(2)^2 - xc(1)^2 + xc(2)^2 - yc(1)^2 + yc(2)^2) - ((-2*xc(1) + 2*xc(2))*x))  / ((-2*yc(1) + 2*yc(2)));

hold on;
if ~exist('color','var')
    plot(x, y,'Linewidth',1);
else
    plot(x, y,color,'Linewidth',2);
end
hold off;
end



% [17:39, 1/16/2020] Herre Faber: Het optimale punt is nu het punt waarvan de loodrechte afstand tot lijn 1 plus de loodrechte afstand naar lijn 2 plus de loodrechte afstand naar lijn 3 minimaal is.
% [17:39, 1/16/2020] Herre Faber: En dat is een lineair probleem.
% [17:40, 1/16/2020] Herre Faber: 3 vergelijkingen 2 onbekenden
% [17:40, 1/16/2020] Herre Faber: In matrixvorm schrijven
% [17:41, 1/16/2020] Herre Faber: A*x=b
% [17:44, 1/16/2020] Herre Faber: Oplossing
% (AT*A)^-1)*AT*b
% [17:44, 1/16/2020] Herre Faber: AT is A getransponeerd
% [17:44, 1/16/2020] Herre Faber: Dakje min 1 is inverse van
% [17:46, 1/16/2020] Herre Faber: Met bollen krijg je volgens mij bij 3 zenders 3 vgl met 3 onbekenden en hoef je bovenstaande formule niet te gebruiken
% [17:46, 1/16/2020] Herre Faber: Wel weer als je 4 zenders gaat gebruiken
% [17:48, 1/16/2020] Herre Faber: In matlab kan je x=A\b doen en dan doet hij onderwater die formule
% [17:48, 1/16/2020] Herre Faber: Ben benieuwd hoe  ver je komt en of het idd werkt