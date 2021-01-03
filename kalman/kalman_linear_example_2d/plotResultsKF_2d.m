function plotResultsKF_2d(t,clean,signals,X_arr,add2title)
close all;
subplot(3,1,1);
plot(clean.position.x, clean.position.y,'g', 'LineWidth', 2,...
    'DisplayName','clean signal');
hold on;
plot(signals(1).sig.x, signals(1).sig.y,'r', 'LineWidth', 2,...
    'LineStyle','--',...
    'DisplayName','disturbed signal');
plot(X_arr(:, 1), X_arr(:, 3),'Color',[0 0 1], ...
    'LineWidth', 2,...
    'DisplayName','KF result');
grid on; grid minor; legend
percentageImprovement = (rmse(signals(1).sig.x-clean.position.x)+rmse(signals(1).sig.y-clean.position.y))/ ...
    (rmse(X_arr(:,1)-clean.position.x)+rmse(X_arr(:,3)-clean.position.y));
title([add2title  ': xy, RMSE improvement '  num2str(round(percentageImprovement,3))])
axis equal;

subplot(3,1,2);
plot(t, clean(1).position.x,'g','LineWidth', 2,'DisplayName','clean x'); hold on;
plot(t, signals(1).sig.x,'r','LineWidth', 2,'DisplayName','disturbed x','LineStyle','--'); hold on;
plot(t,  X_arr(:, 1),'Color',[0.7 0.7 0.1], 'LineWidth', 2,'DisplayName','KF result x');
grid on; grid minor; legend
percentageImprovement = (rmse(signals(1).sig.x-clean.position.x)/rmse(X_arr(:,1)-clean.position.x));
title([add2title ': x, RMSE improvement ' num2str(round(percentageImprovement,3))])


subplot(3,1,3);
plot(t, clean(1).position.y,'g','LineWidth', 2,'DisplayName','clean y'); hold on;
plot(t, signals(1).sig.y,'r','LineWidth', 2,...
    'LineStyle','--',...
    'DisplayName','disturbed y'); hold on;
plot(t, X_arr(:, 3),'Color',[0.7 0.7 0.1], 'LineWidth', 2,'DisplayName','KF result y');
grid on; grid minor; legend
percentageImprovement = (rmse(signals(1).sig.y-clean.position.y)/rmse(X_arr(:,3)-clean.position.y));
title([add2title ': y, RMSE improvement ' num2str(round(percentageImprovement,3))])

if not(exist('add2title','var'))
    add2title = '';
else
    add2title = [add2title ': '];
end

% title([add2title num2str(round(rmse(X_arr(:,1)-clean.position),3))])
grid on; grid minor;
end

