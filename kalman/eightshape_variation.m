function [x,y] = eightshape_variation(t,maxX,maxY)
if not(exist('maxX','var'))
    maxX = 1;
end
if not(exist('maxY','var'))
    maxY = 1;
end
[y,x] = eightshape(t);
x = x.*(cos(t/200)+1);
[r,c] = size(t);
if c>r
    y = y+linspace(-0.1,0.1,length(t));
else
    y = y+linspace(-0.1,0.1,length(t))';
end
x = (maxX/2)*(x./max(x)); % /2 to prevent double maxX
y = (maxY/2)*(y./max(y));
end

