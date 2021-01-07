function [] = KF_multiple_similar_sensors_1d_withvel()

[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA();
[X,P,X_arr,Q,F] = setX_P_Xarr_Q_F(n,dt);
H = [1 0;
    0 1];% observation matrix

%% fusion
for i = 1:n
    if (i == 1)
        [X, P] = init_KF(X, signals(1).sig(i, 1)); % initialize the state using the 1st sensor
    else
        [X, P] = prediction(X, P, Q, F);
        [y,R] = getMeasurementData(signals,velocity,1,i);  [X, P] = update(X, P, y, R, H);
    end
    X_arr(i, :) = X(1,:);
end

plotResultsKF(t,clean,signals,X_arr,'withvelocity');
plot(t, signals(1).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 1');
legend();
end

function [y,R] = getMeasurementData(signals,velocity,n,i)
y = [signals(n).sig(i) velocity(n).sig(i)];
R = [signals(n).var(i) 0; 0 velocity(n).var(i)];
end