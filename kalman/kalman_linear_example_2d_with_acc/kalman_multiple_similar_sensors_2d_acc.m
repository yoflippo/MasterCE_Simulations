function [] = kalman_multiple_similar_sensors_2d_acc()

[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA_2d();
cd(fileparts(mfilename('fullpath')));

[X,P,X_arr,Q,F] = setX_P_Xarr_Q_F_2d_acc(n,dt);
H = [1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 1 0;];% observation matrix

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
end

function [y,R] = getMeasurementData(signals,velocity,n,i)
y = [signals(n).sig.x(i) velocity(n).sig.x(i) ...
    signals(n).sig.y(i) velocity(n).sig.y(i)]';
vari = [signals(n).var(i) velocity(n).var(i)...
    signals(n).var(i) velocity(n).var(i)]';
R = vari.*eye(numel(vari));
end