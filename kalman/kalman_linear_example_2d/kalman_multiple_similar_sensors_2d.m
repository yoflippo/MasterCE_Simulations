function [] = kalman_multiple_similar_sensors_2d()

[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA_2d();
[X,P,X_arr,Q,F] = setX_P_Xarr_Q_F_2d(n,dt);
H = [1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1;]% observation matrix


% fusion
for i = 1:n
    if (i == 1)
        y = getMeasurementData(signals,velocity,1,i);
        [X, P] = init_kalman_2d(X, y); % initialize the state using the 1st sensor
    else
        [X, P] = prediction_2d(X, P, Q, F);
        [y,R] = getMeasurementData(signals,velocity,1,i);  
        [X, P] = update_2d(X, P, y, R, H);
    end
    X_arr(i, :) = X;
end

plotResultsKF_2d(t,clean,signals,X_arr,'2d');
% plot(t, signals(1).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 1');
% legend();
end

function [y,R] = getMeasurementData(signals,velocity,n,i)
y = [signals(n).sig.x(i) velocity(n).sig.x(i) signals(n).sig.y(i) velocity(n).sig.y(i)]';
vari = [signals(n).var(i) velocity(n).var(i) signals(n).var(i) velocity(n).var(i)]';
R = vari.*eye(numel(vari));
end