function [XYclean,XYwmpm,XYuwb] = createSimulatedData()
fs = 100; dt = 1/fs; n = 20; t = 0:dt:n;
[XYclean,XYwmpm] = createWMPMdata(t);
XYuwb = createUWBdata(XYclean,t,fs);

if isequal(nargout,0)
    close all;
    plot(XYclean(1,:),XYclean(2,:),'b','DisplayName','original');
    hold on;
    plot(XYwmpm(1,:),XYwmpm(2,:),'r','DisplayName','wmpm');
    plot(XYuwb(1,:),XYuwb(2,:),'m','DisplayName','uwb');
    grid on; grid minor; legend;
    title('Simulated data');
end
end

