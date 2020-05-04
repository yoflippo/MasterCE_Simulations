close all
clearvars
clc

k = [0; 15];% Tag
A = [-15 0 20 5;
      10 30 -5 -8];
  
combinations = nchoosek(1:length(A),2)';
% find some color
cols = colormap("hsv");
colsidx = round(linspace(1,length(cols)-50,length(combinations)));
cols = cols(colsidx,:);
cnt = 1;
for nc = combinations
    [c] = tdoa_lines(A(:,nc(1)),A(:,nc(2)),k,cols(cnt,:));
    cnt = cnt + 1;
end