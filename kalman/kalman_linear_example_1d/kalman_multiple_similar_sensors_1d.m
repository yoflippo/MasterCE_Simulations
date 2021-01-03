function [] = kalman_multiple_similar_sensors_1d()

[dt,t,n,signals,~,clean] = KF_INPUT_DATA();
[X,P,X_arr,Q,F] = setX_P_Xarr_Q_F(n,dt);
H = [1 0];% observation matrix


% fusion
for i = 1:n
    if (i == 1)
        [X, P] = init_kalman(X, signals(1).sig(i, 1)); % initialize the state using the 1st sensor
    else
        [X, P] = prediction(X, P, Q, F);
        [y,R] = getMeasurementData(signals,1,i);  [X, P] = update(X, P, y, R, H);
%         [y,R] = getMeasurementData(signals,2,i);  [X, P] = update(X, P, y, R, H);
%         [y,R] = getMeasurementData(signals,3,i);  [X, P] = update(X, P, y, R, H);
%         [y,R] = getMeasurementData(signals,4,i);  [X, P] = update(X, P, y, R, H);
    end
    %     hold on; draw2DCovarianceEllipse(P/50,[t(i) signal(i)]);
    X_arr(i, :) = X;
end

plotResultsKF(t,clean,signals,X_arr,'novelocity');
plot(t, signals(1).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 1');
% plot(t, signals(2).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 2')
% plot(t, signals(3).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 3')
% plot(t, signals(4).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 4')
legend();
end

function [y,R] = getMeasurementData(signals,n,i)
y = [signals(n).sig(i)];
R = [signals(n).var(i)];
end