close all
clearvars
clc

% Anker 1:
A = [-15; 10];
% Anker 2:
B = [0; 30];
% afstand tussen anker 1 en 2:
rAB = norm(B-A);
% Tag:
k = [-10; 25];
% Echte afstand tussen tag en anker 1:
dr1 = dis(A(1),A(2),k(1),k(2));
% Echte afstand tussen tag en anker 2:
dr2 = dis(B(1),B(2),k(1),k(2));
% Afstand als gevolg van time difference:
dd = dr2-dr1;
figure
hold on
% Alle mogelijke afstanden tussen tag en anker 1 aflopen:
for Ak = 3:0.5:rAB
% afstand tussen tag en anker 2:  
    ddAk = dd+Ak;
    h1 = drawcircle(A(1),A(2),Ak,'r');
    h2 = drawcircle(B(1),B(2),ddAk,'b');
    [c1,c2] = circleIntersectionHF(A,B,Ak,ddAk);
    plot(c1(1),c1(2),'ro','Linewidth',2,'MarkerSize',5)
    plot(c2(1),c2(2),'bo','Linewidth',2,'MarkerSize',5)
end
plot(A(1),A(2),'r+','Linewidth',2,'MarkerSize',20)
plot(B(1),B(2),'b+','Linewidth',2,'MarkerSize',20)  
plot(k(1),k(2),'k+','Linewidth',3,'MarkerSize',18)
axis equal
   
