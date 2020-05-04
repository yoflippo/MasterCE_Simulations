clearvars
close all
c = physconst('LightSpeed');
B = 3.1e9:1e5:10.6e9;
cm = 100;
rr = cm*c./(2*B);
plot(B,rr)
title('Estimated range accuracy in UWB')
xlabel('Bandwith (GHz)')
ylabel('Estimated range accuracy [cm]')
grid on
grid minor
