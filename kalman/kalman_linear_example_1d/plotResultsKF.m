function plotResultsKF(t,clean,signals,X_arr,add2title)
figure;
plot(t, clean.position,'g', 'LineWidth', 2,'DisplayName','clean signal');
hold on;
plot(t, X_arr(:, 1),'Color',[1 0.1 0.1], 'LineWidth', 2,'DisplayName','KF result');



if not(exist('add2title','var'))
    add2title = '';
else
    add2title = [add2title ': '];
end

percentageImprovement = (rmse(signals(1).sig-clean.position)/rmse(X_arr(:,1)-clean.position));
title([add2title ': x, RMSE improvement ' num2str(round(percentageImprovement,3))])
grid on;
end

