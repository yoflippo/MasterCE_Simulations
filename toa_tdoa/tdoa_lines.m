function [c] = tdoa_lines(A,B,k,color)

if ~exist('color','var')
    color = 'k';
end

rAB = norm(B-A);% afstand tussen anker 1 en 2
dr1 = dis(A(1),A(2),k(1),k(2));% Echte afstand tussen tag en anker 1
dr2 = dis(B(1),B(2),k(1),k(2));% Echte afstand tussen tag en anker 2
dd = dr2-dr1;% Afstand als gevolg van time difference

hold on; 
cnt = 1;

for Ak = 0:0.2:rAB*2 % Alle mogelijke afstanden tussen tag en anker 1 aflopen
    ddAk = dd+Ak;% afstand tussen tag en anker 2:  
    [c1(cnt,1:2),c2(cnt,1:2)] = circleIntersectionHF(A,B,Ak,ddAk);
    cnt = cnt + 1;
end

plot(c1(:,1),c1(:,2),'Color',color);
plot(c2(:,1),c2(:,2),'Color',color);

plot(A(1),A(2),'+','Linewidth',3,'MarkerSize',20,'Color',color)
plot(B(1),B(2),'+','Linewidth',3,'MarkerSize',20,'Color',color)  
plot(k(1),k(2),'^','Linewidth',3,'MarkerSize',10,'Color',color)
axis equal

c = [[c1(:,1); c2(:,1)] [c1(:,2); c2(:,2)]];