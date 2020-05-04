close all; clearvars; clc;

w = [1 3 4];
s = [2 5 -1; 
    3 1 -1];

sumw = sum(w);
ws = s.*w;
sumws = sum(ws,2);
t = -sumws/sumw

st = s+t
sumwst = sum(st.*w,2)