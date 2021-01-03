function [] = kalman_multiple_similar_sensors_2d_acc()

[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA_2d();
cd(fileparts(mfilename('fullpath')));

[X,P,X_arr,Q,F] = setX_P_Xarr_Q_F_2d_acc(n,dt);
H = eye(length(P));% observation matrix
H(3,3) = 0; %set acc measurement to zero
H(6,6) = 0;

% fusion
for i = 1:n
    if (i == 1)
        y = getMeasurementData(signals,velocity,1,i);
        [X, P] = init_kalman_2d_acc(y); % initialize the state using the 1st sensor
    else
        [X, P] = prediction_2d_acc(X, P, Q, F);
        [y, R] = getMeasurementData(signals,velocity,1,i);  
        [X, P] = update_2d_acc(X, P, y, R, H);
    end
    X_arr(i, :) = X;
end

plotResultsKF_2d_acc(t,clean,signals,X_arr,'2d acc');
% plot(t, signals(1).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 1');
% legend();
end

function [y,R] = getMeasurementData(signals,velocity,n,i)
y = [signals(n).sig.x(i) velocity(n).sig.x(i) 0 ...
    signals(n).sig.y(i) velocity(n).sig.y(i) 0]';
vari = [signals(n).var(i) velocity(n).var(i) 200 ... 
    signals(n).var(i) velocity(n).var(i) 200]';
R = vari.*eye(numel(vari));
end