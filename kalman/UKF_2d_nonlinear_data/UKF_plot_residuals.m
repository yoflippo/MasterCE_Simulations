function UKF_plot_residuals(position,residualsV,UKF_x)

figure('units','normalized','outerposition',[0.1 0.1 0.8 0.8])
subplot(3,1,1); title('Residuals');
plot(residualsV(:,1),'k--','DisplayName','residuals rotational velocity'); 
hold on;
plot(residualsV(:,2),'b:','DisplayName','residuals resultant. velocity'); 
grid on; grid minor; legend;

subplot(3,1,2); title('Clean versus noisy position y ');
cpx = position.x2(1:length(UKF_x(:,1)));
upx = UKF_x(:,1);
plot(cpx,'g','DisplayName','clean pos. x');  hold on;
plot(upx,'m','DisplayName','UKF pos. x'); 
plot(abs(cpx-upx),'r','DisplayName','error');
grid on; grid minor; legend;

subplot(3,1,3); title('Clean versus noisy position y');
cpy = position.y2(1:length(UKF_x(:,2)));
upy = UKF_x(:,2);
plot(cpy,'g','DisplayName','clean pos.y');  hold on;
plot(upy,'m','DisplayName','UKF pos. y');
plot(abs(cpy-upy),'r','DisplayName','error');
grid on; grid minor; legend;

subplot(3,1,1); 
hold on;
plot(sqrt((cpy-upy).^2+(cpx-upx).^2),'DisplayName','error KF vs. clean');
plot(smooth(sqrt(residualsV(:,1).^2+residualsV(:,2).^2),50),'r','DisplayName','RMS residuals');
end

