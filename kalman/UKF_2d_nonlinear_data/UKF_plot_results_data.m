function [RMSE_UKF,RMSE_RAW] = UKF_plot_results_data(ts,clean,position,UKFout,velocity,add2title,blVisible)

if not(exist('blVisible','var'))
    blVisible = true;
end

if blVisible
    figure('Visible','on');
else
    figure('Visible','off');
end

if not(exist('add2title','var'))
    add2title = '';
else
    add2title = [add2title ' '];
end
nOutput = length(UKFout);

idxPosX = 1;
idxPosY = 2;
idxAngRate = 4;
idxVelRes = 6;
idxAngles = 3;

subplot(3,3,[1 2 4 5]);
plot(position.x, position.y,'r', 'LineWidth', 2,'LineStyle','--','DisplayName','disturbed signal'); hold on;
plot(clean.position.x, clean.position.y,'g', 'LineWidth', 2,'DisplayName','clean signal');
plot(UKFout(:, idxPosX), UKFout(:, idxPosY),'Color',[0 0 1],'LineWidth', 2,'DisplayName','KF result');
grid on; grid minor; legend
RMSE_UKF = rmse(distances([clean.position.x(1:nOutput) clean.position.y(1:nOutput)] , [UKFout(:,[idxPosX idxPosY])]) );
RMSE_RAW = rmse(distances([position.x position.y],[position.xDownSampledOpti position.yDownSampledOpti]));

title([add2title  ' xy, RMSE_UKF '  num2str(round(RMSE_UKF,1))]); axis equal;

subplot(3,3,3);
plot(ts.t, position.x,'r','LineWidth', 2,'DisplayName','disturbed x','LineStyle','--'); hold on;
plot(ts.t2(1:nOutput), clean.position.x(1:nOutput),'g','LineWidth', 2,'DisplayName','clean x'); hold on;
plot(ts.t2(1:nOutput),  UKFout(:, idxPosX),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result x');
grid on; grid minor; title([add2title ' x'])

subplot(3,3,6);
plot(ts.t, position.y,'r','LineWidth', 2,'LineStyle','--','DisplayName','disturbed y'); hold on;
plot(ts.t2(1:nOutput), clean.position.y(1:nOutput),'g','LineWidth', 2,'DisplayName','clean y'); hold on;
plot(ts.t2(1:nOutput), UKFout(:, idxPosY),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result y');
grid on; grid minor; title([add2title ' y'])

subplot(3,3,7);
plot(ts.t2, velocity.angularRate,'r','LineWidth', 2,'DisplayName','disturbed vel x','LineStyle','--'); hold on;
% plot(ts.t2(1:nOutput), clean.velocity.angularRate,'g','LineWidth', 2,'DisplayName','clean angular rate'); hold on;
plot(ts.t2(1:nOutput),  UKFout(:, idxAngRate),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result velx');
grid on; grid minor; title([add2title ' angular rate'])

subplot(3,3,8);
plot(ts.t2, velocity.res,'r','LineWidth', 2,'DisplayName','disturbed vel res','LineStyle','--'); hold on;
% plot(ts.t2(1:nOutput), clean.velocity.res,'g','LineWidth', 2,'DisplayName','clean vel res'); hold on;
plot(ts.t2(1:nOutput),  UKFout(1:nOutput, idxVelRes),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result vel y');
grid on; grid minor; title([add2title ' resultant velocity'])

subplot(3,3,9);
% plot(ts.t2, velocity.angles,'r','LineWidth', 2,'DisplayName','disturbed angles','LineStyle','--'); hold on;
% plot(ts.t2(1:nOutput), clean.velocity.angles,'g','LineWidth', 2,'DisplayName','clean angles'); hold on;
plot(ts.t2(1:nOutput),  UKFout(1:nOutput, idxAngles),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result angles');
grid on; grid minor; 
title([add2title ' Angles'])
end

function d = distances(posa,posb)
d =sqrt((posb(:,1)-posa(:,1)).^2 + (posb(:,2)-posa(:,2)).^2);
end