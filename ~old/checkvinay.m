%% Check of equations of Vinay, see his thesis eq 4.2 and 4.3
close all;
clearvars; 
clc;

syms x y xi yi xj yj xj1 xj2 yj1 yj2 ri

%% equations 4.2
z1 = ((x-xj)*(xi-xj)+(y-yj)*(yi-yj)) == ((x-xj)^2 + (y-yj)^2 -ri^2 + (xi-xj)^2 + (yi-yj)^2)/2 ;
z2 = (x-xj1+xj2-xi)^2 + (y-yj1+yj2-yi)^2 == ri^2;
z2 = expand(z2);

xj = 2;
xj1 = xj;
xj2 = xj;
yj = 3;
yj1 = yj;
yj2 = yj;
xi = 4;
yi = 5;

z1 = simplify(eval(z1))
z2 = simplify(eval(z2))
isequal(z1,z2)

%% original source: William S. Murphy Jr, 2007