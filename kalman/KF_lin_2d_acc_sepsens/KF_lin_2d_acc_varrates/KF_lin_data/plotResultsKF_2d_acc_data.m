function plotResultsKF_2d_acc_data(ts,clean,signals,X_arr,velocity,add2title)
if not(exist('add2title','var'))
    add2title = '';
else
    add2title = [add2title ' '];
end
nOutput = length(X_arr);

subplot(3,2,[1 2]);
plot(signals.x, signals.y,'r', 'LineWidth', 2,'LineStyle','-','DisplayName','disturbed signal');hold on;
plot(clean.position.x, clean.position.y,'g', 'LineWidth', 2,'DisplayName','clean signal');
plot(X_arr(:, 1), X_arr(:, 4),'Color',[0 0 1],'LineWidth', 2,'DisplayName','KF result');
grid on; grid minor; legend
% percentageImprovement = (rmse(signals.x-clean.position.x)+rmse(signals.y-clean.position.y))/ ...
%     (rmse(X_arr(:,1)-ts.x2)+rmse(X_arr(:,4)-ts.y2));
% kfImprovement = num2str(round(rmse(X_arr(:,1)-ts.x2) + rmse(X_arr(:,4)-ts.y2),3));
% title([add2title  ' xy, RMSE improvement '  num2str(round(percentageImprovement,3)) ' KF rmse: ' kfImprovement])
axis equal;
title([add2title ' xy'])

subplot(3,2,3);
plot(ts.t_p, signals.x,'r','LineWidth', 2,'DisplayName','disturbed x','LineStyle','--'); hold on;
plot(ts.t_v(1:nOutput), clean.position.x(1:nOutput),'g','LineWidth', 2,'DisplayName','clean x'); hold on;
plot(ts.t_v(1:nOutput),  X_arr(:, 1),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result x');
grid on; grid minor; legend
% percentageImprovement = rmse_improvement(clean.position.x,signals.x,X_arr(:,1));
% title([add2title ' x, RMSE improvement ' num2str(round(percentageImprovement,3))])
title([add2title ' x'])

subplot(3,2,4);
plot(ts.t_p, signals.y,'r','LineWidth', 2,'LineStyle','--','DisplayName','disturbed y'); hold on;
plot(ts.t_v(1:nOutput), clean.position.y(1:nOutput),'g','LineWidth', 2,'DisplayName','clean y'); hold on;
plot(ts.t_v(1:nOutput), X_arr(:, 4),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result y');
grid on; grid minor; legend
% percentageImprovement = rmse_improvement(clean.position.y,signals.y,X_arr(:,4));
% title([add2title ' y, RMSE improvement ' num2str(round(percentageImprovement,3))])
title([add2title ' y '])

subplot(3,2,5);
plot(ts.t_v(1:nOutput), velocity.sig.x(1:nOutput),'r','LineWidth', 2,'DisplayName','disturbed vel x','LineStyle','--'); hold on;
plot(ts.t_v(1:nOutput), clean.velocity.x(1:nOutput),'g','LineWidth', 2,'DisplayName','clean vel x'); hold on;
plot(ts.t_v(1:nOutput),  X_arr(:, 2),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result vel x');
grid on; grid minor; legend
% percentageImprovement = rmse_improvement(clean.velocity.x,velocity.sig.x,X_arr(:,2));
% title([add2title ' x vel, RMSE improvement ' num2str(round(percentageImprovement,3))])
title([add2title ' x vel'])

subplot(3,2,6);
plot(ts.t_v(1:nOutput), velocity.sig.y(1:nOutput),'r','LineWidth', 2,'DisplayName','disturbed vel y','LineStyle','--'); hold on;
plot(ts.t_v(1:nOutput), clean.velocity.y(1:nOutput),'g','LineWidth', 2,'DisplayName','clean vel y'); hold on;
plot(ts.t_v(1:nOutput),  X_arr(:, 5),'Color',[0 0 1], 'LineWidth', 2,'DisplayName','KF result vel y');
grid on; grid minor; legend
% percentageImprovement = rmse_improvement(clean.velocity.y,velocity.sig.y,X_arr(:,5));
% title([add2title ' y vel, RMSE improvement ' num2str(round(percentageImprovement,3))])
title([add2title ' y vel'])
end