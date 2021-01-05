function [] = kf_2d_acc_varrate()

[dt,t,n,signals,velocity,clean,dt2,t2,n2] = KF_INPUT_DATA_2d_varrates();
cd(fileparts(mfilename('fullpath')));

[X,P,X_arr,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(n,dt,n2,dt2);

% fusion
for i = 1:n
    if (i == 1)
        y = getMeasurementData_varrates(signals,velocity,1,i);
        [X, P] = init_kalman_2d_acc_varrates(y);
    else
        [X, P] = prediction_2d_acc_varrates(X, P, Q, F);
        %% GET variate updatereate working
        [y, R] = getMeasurementData_varrates(signals,velocity,
        1,i);
        [X, P] = update_2d_acc_varrates(X, P, y, R, H);
    end
    X_arr(i, :) = X;
    P_arr(i).M = P;
end

plotResultsKF_2d_acc(t,clean,signals,X_arr,velocity,'2d acc');
figure;
[X_arr, P, K, Pp] = rts_smooth(X_arr, P_arr, F, Q);
plotResultsKF_2d_acc(t,clean,signals,X_arr,velocity,'2d acc smoothed');
end

