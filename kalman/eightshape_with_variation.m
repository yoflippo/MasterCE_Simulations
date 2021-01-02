function [x,y] = eightshape_with_variation(t,maxX,maxY)
if not(exist('maxX','var'))
    maxX = 1;
end
if not(exist('maxY','var'))
    maxY = 1;
end
[y,x] = eightshape(t);
x = x.*(cos(t/200)+1);
y = y+linspace(-0.1,0.1,length(t));
x = maxX*(x./max(x));
y = maxY*(y./max(y));
end

