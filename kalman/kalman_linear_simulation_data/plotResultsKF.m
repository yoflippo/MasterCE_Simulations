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

title([add2title num2str(round(rmse(X_arr(:,1)-clean.position),3))])
grid on;
end

