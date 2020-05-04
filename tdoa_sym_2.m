hold off
clearvars;
clc
syms x y x1 y1 x2 y2 d;

%% Example data
m1 = -3; m2 = 1;

xa = [2 -3 5];
ya = [2 -4 -3] ;

for n = nchoosek(1:length(xa),2)'
    i = n(1); j = n(2);
    tdoa_sym_func_graph(xa(i),xa(j),ya(i),ya(j),m1,m2)
    hold on;
end

for l = 1:length(xa)
        text(xa(l)-0.5,ya(l)-0.5,num2str(l))
end