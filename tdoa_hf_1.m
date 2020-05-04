close all;
clearvars;
clc;

A = [-15; 10];
B = [0; 1];
k = [-20; 25];
dr1 = dis(A(1),A(2),k(1),k(2));
dr2 = dis(B(1),B(2),k(1),k(2));
dd = abs(dr2-dr1);

for d1 = 1:0.1:20
    d2 = d1+dd;
%     drawcircle(A(1),A(2),d1);
%     drawcircle(B(1),B(2),d2);
    [c1,c2] = circleIntersectionHF(A,B,d1,d2);
    plot(c1(1),c1(2),'r+','Linewidth',3,'MarkerSize',5)
    plot(c2(1),c2(2),'b+','Linewidth',3,'MarkerSize',5)
    hold on;
end
plot(A(1),A(2),'r+','Linewidth',2,'MarkerSize',20)
plot(B(1),B(2),'b+','Linewidth',2,'MarkerSize',20)  
plot(k(1),k(2),'k+','Linewidth',3,'MarkerSize',18)
axis equal
   
