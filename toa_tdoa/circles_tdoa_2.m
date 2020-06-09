close all; clearvars; clc;

path = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(fileparts(path),'helper')));

xc = [-4 -15 5];
yc = [20 -10 9];
k = [-1; -2];

intersecs = [];
for combs = nchoosek(1:length(xc),2)'
    A = [xc(combs(1)); yc(combs(1))];
    B = [xc(combs(2)); yc(combs(2))];
    
    dr1 = dis(A,k);
    dr2 = dis(B,k);
    dd = dr2-dr1;
    
    for d1 = 15:1:30
        d2 = d1+dd;
        drawcircle(A(1),A(2),d1,[0.5 0.5 0.5]*1.5);
        drawcircle(B(1),B(2),d2,[0.5 0.5 0.5]*1.5);
        [c1,c2] = circleIntersectionHF(A,B,d1,d2);
        intersecs = [intersecs; [c1'; c2']];
        hold on;
    end
end

plot(intersecs(:,1),intersecs(:,2),'r.','Linewidth',3,'MarkerSize',20)
plot(xc,yc,'b^','Linewidth',3,'MarkerSize',10)
plot(k(1),k(2),'k+','Linewidth',3,'MarkerSize',18)

grid on; grid minor; xlabel('x-coordinates'); ylabel('y-coordinates');
title('TDOA');

axis([-60 40 -40 50]); axis equal;
export_fig(gcf,[mfilename '.png'],'-transparent','-r300');
