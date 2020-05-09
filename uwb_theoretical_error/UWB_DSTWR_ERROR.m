clearvars; close all; clc
cm = 100;
h=figure('WindowState','normal');
for delta_reply = [1e-6 10e-6 100e-6]
    ea_eb = (0:20)/1e6; %ppm
    tau_err = delta_reply*ea_eb/4; 
    semilogy(ea_eb*1e6,cm*UWB_dis_tof(tau_err),...
        'DisplayName',['\Delta_{reply} = ' num2str(delta_reply)  ' [s]'],...
        'LineWidth',2);
    hold on;
end
title('Ranging error in SDS-TWR due to \Delta_{reply}');
xlabel('e_A - e_B [ppm]'); ylabel('Error [cm]');
legend('Location','best')
grid on; grid minor
pause(1)
saveTightFigure(h,[mfilename '.png'])
close(h);