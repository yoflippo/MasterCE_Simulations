function UKF_plot_results(ts,clean,position,X_arr,velocity,add2title)
if not(exist('add2title','var'))
    add2title = '';
else
    add2title = [add2title ' '];
end
nOutput = length(X_arr);

idxPosX = 1;
idxPosY = 4;
idxVelX = 2;
idxVelY = 5;

subplot(3,2,[1 2]);
plot(position.x, position.y,'r', 'LineWidth', 2,'LineStyle','--','DisplayName','disturbed signal');hold on;
plot(clean.position.x, clean.position.y,'g', 'LineWidth', 2,'DisplayName','clean signal');
plot(X_arr(:, idxPosX), X_arr(:, idxPosY),'Color',[0 0 1],'LineWidth', 2,'DisplayName','KF result');
grid on; grid minor; legend
percentageImprovement = (rmse(position.x-clean.position.x)+rmse(position.y-clean.position.y))/ ...
    (rmse(X_arr(:,1)-position.x2(1:nOutput))+rmse(X_arr(1:nOutput,4)-position.y2(1:nOutput)));
title([add2title  ' xy, RMSE improvement '  num2str(round(percentageImprovement,3))])
axis equal;

subplot(3,2,3);
plot(ts.t, position.x,'r','LineWidth', 2,'DisplayName','disturbed x','LineStyle','--'); hold on;
plot(ts.t, clean.position.x,'g','LineWidth', 2,'DisplayName','clean x'); hold on;
plot(ts.t2(1:nOutput),  X_arr(:, idxPosX),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result x');
grid on; grid minor; legend
title([add2title ' x'])

subplot(3,2,4);
plot(ts.t, position.y,'r','LineWidth', 2,'LineStyle','--','DisplayName','disturbed y'); hold on;
plot(ts.t, clean.position.y,'g','LineWidth', 2,'DisplayName','clean y'); hold on;
plot(ts.t2(1:nOutput), X_arr(:, idxPosY),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result y');
grid on; grid minor; legend
title([add2title ' y'])

subplot(3,2,5);
plot(ts.t2, velocity.x,'r','LineWidth', 2,'DisplayName','disturbed vel x','LineStyle','--'); hold on;
plot(ts.t2, clean.velocity.x,'g','LineWidth', 2,'DisplayName','clean velx'); hold on;
plot(ts.t2(1:nOutput),  X_arr(:, idxVelX),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result velx');
grid on; grid minor; legend
title([add2title ' x velocity'])

subplot(3,2,6);
plot(ts.t2, velocity.y,'r','LineWidth', 2,'DisplayName','disturbed vel y','LineStyle','--'); hold on;
plot(ts.t2, clean.velocity.y,'g','LineWidth', 2,'DisplayName','clean vel y'); hold on;
plot(ts.t2(1:nOutput),  X_arr(1:nOutput, idxVelY),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result vel y');
grid on; grid minor; legend
title([add2title ' y velocity'])
end