clearvars; close all; clc
cm = 100;
h=figure('WindowState','normal');
for treply = [10e-7 10e-6 100e-6 1000e-6]
    ea_eb = (0:20)/1e6; %ppm
    tau_err = treply*ea_eb/2; 
    % tt1 = 0;
    % ta1 = 1000e-9;
    % ta2 = treplyb + ta1;
    % tt2 = treplyb + ta1 + ta2;
    semilogy(ea_eb*1e6,cm*UWB_dis_tof(tau_err),...
        'DisplayName',['t_{reply} = ' num2str(treply) ' [s]'],...
        'LineWidth',2);
    hold on;
end
title('Ranging error in TWR due to clock drift between device A and B');
xlabel('e_A - e_B [ppm]'); ylabel('Error [cm]');
legend('Location','best')
grid on; grid minor
pause(1)
saveTightFigure(h,[mfilename '.png'])
pause(1)
close(h)
