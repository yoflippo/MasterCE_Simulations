function UKF_plot_residuals(clean,position,residualsV,UKF_x)

figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8])
subplot(3,1,1); title('Residuals');
plot(smooth(residualsV(:,1),50),'DisplayName','rot. vel.'); 
hold on;
plot(smooth(residualsV(:,2),50),'DisplayName','res. vel.'); 
grid on; grid minor; legend;

subplot(3,1,2); title('Clean versus noisy position y ');
plot(position.x2(1:length(UKF_x(:,1))),'g','DisplayName','clean pos. x');  hold on;
plot(UKF_x(:,1),'r','DisplayName','UKF pos. x'); 
grid on; grid minor; legend;

subplot(3,1,3); title('Clean versus noisy position y');
plot(position.y2(1:length(UKF_x(:,2))),'g','DisplayName','clean pos.y');  hold on;
plot(UKF_x(:,2),'r','DisplayName','UKF pos. y'); 
grid on; grid minor; legend;
end

