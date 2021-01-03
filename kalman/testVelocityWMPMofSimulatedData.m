function [outputArg1,outputArg2] = testVelocityWMPMofSimulatedData()
[XYclean,XYwmpm,XYuwb,tempspecs] = createSimulatedData();
x = XYwmpm(1,:); y = XYwmpm(2,:);
xvel = gradient(x,1/tempspecs.fs);
yvel = gradient(y,1/tempspecs.fs);
subplot(2,1,1);
plot(tempspecs.t,xvel);
subplot(2,1,2);
plot(tempspecs.t,yvel);
end

