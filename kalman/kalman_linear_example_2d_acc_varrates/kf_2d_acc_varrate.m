function [] = kf_2d_acc_varrate()

[signals,velocity,clean,acceleration,ts] = KF_INPUT_DATA_2d_varrates();
cd(fileparts(mfilename('fullpath')));

[X,P,X_arr,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(ts);

% fusion
cnt = 1;
for i = 1:ts.n2
    if i == 1
        y = getMeasurementData_varrates(signals,velocity,1,i);
        [X, P] = init_kalman_2d_acc_varrates(y);
    else
        if isequal(cnt,ts.fs)
            cnt = 0;
            [X, P] = prediction_2d_acc_varrates(X, P, Q1, F1);
            [y, R] = getMeasurementData_varrates(signals,velocity,1,floor(i/ts.fs),true);
            [X, P] = update_2d_acc_varrates(X, P, y, R, H1);
        end
        [X, P] = prediction_2d_acc_varrates(X, P, Q2, F2);
        [y, R] = getMeasurementData_varrates(signals,velocity,1,i);
        [X, P] = update_2d_acc_varrates(X, P, y, R, H2);
        
        cnt = cnt + 1;
    end
    X_arr(i, :) = X;
    P_arr(i).M = P;
end
close all;
plotResultsKF_2d_acc_varrates(ts,clean,signals,X_arr,velocity,'2d acc varrates');
figure;
[X_arr, P, K, Pp] = rts_smooth(X_arr, P_arr, F2, Q2);
plotResultsKF_2d_acc_varrates(ts,clean,signals,X_arr,velocity,'2d acc varrates smoothed');
distFig
end

