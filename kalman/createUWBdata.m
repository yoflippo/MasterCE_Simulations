function XYuwb = createUWBdata(XYclean,t,fs)
fsuwb = 8;
tuwb = 0:1/fsuwb:t(end);
x = interp1(t,XYclean(1,:),tuwb);
y = interp1(t,XYclean(2,:),tuwb);
factor = 500;
xuwb = x + factor*randn(size(x));
yuwb = y + factor*randn(size(y));
XYuwb = [xuwb; yuwb];
end

