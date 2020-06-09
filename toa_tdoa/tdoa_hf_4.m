close all
clearvars
clc
figure; hold on;

A = [-15; 10];% Anker 1
B = [0; 30];% Anker 2

k = [i; 20];% Tag

rAB = norm(B-A);% afstand tussen anker 1 en 2
dr1 = dis(A,k);% Echte afstand tussen tag en anker 1
dr2 = dis(B,k);% Echte afstand tussen tag en anker 2
dd = dr2-dr1;% Afstand als gevolg van time difference

cnt = 1;

for Ak = 0:0.1:rAB % Alle mogelijke afstanden tussen tag en anker 1 aflopen
    ddAk = dd+Ak;% afstand tussen tag en anker 2:
    [c1(cnt,1:2),c2(cnt,1:2)] = circleIntersectionHF(A,B,Ak,ddAk);
    cnt = cnt + 1;
end

plot(c1(:,1),c1(:,2));
plot(c2(:,1),c2(:,2));
plot(A(1),A(2),'r^','Linewidth',3,'MarkerSize',20)
plot(B(1),B(2),'b^','Linewidth',3,'MarkerSize',20)
plot(k(1),k(2),'k+','Linewidth',3,'MarkerSize',10)
axis equal

