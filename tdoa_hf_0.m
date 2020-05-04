close all;
clearvars;
clc;

A = [-80; -20];
B = [-100; -10];
k = [0 0];

% for d1 = -10:10
d1 = dis(A(1),A(2),k(1),k(2));
d2 = dis(B(1),B(2),k(1),k(2));
dd = abs(d2-d1);
drawcircle(A(1),A(2),d1);
drawcircle(B(1),B(2),d2);
plot(k(1),k(2),'k+','Linewidth',3,'MarkerSize',18)
% end

[c1,c2] = circleIntersectionHF(A,B,d1,d2);
plot(c1(1),c1(2),'r+','Linewidth',3,'MarkerSize',18)
plot(c2(1),c2(2),'b+','Linewidth',3,'MarkerSize',18)