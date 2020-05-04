close all;
clearvars;
clc;

A = [-90; -20];
B = [-90; -30];
r = [50 50];

drawcircle(A(1),A(2),r(1));
drawcircle(B(1),B(2),r(2));

[c1,c2] = circleIntersectionHF(A,B,r(1),r(2));
plot(c1(1),c1(2),'r+','Linewidth',3,'MarkerSize',18)
plot(c2(1),c2(2),'b+','Linewidth',3,'MarkerSize',18)