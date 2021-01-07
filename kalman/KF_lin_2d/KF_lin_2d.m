function [] = KF_lin_2d()

[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA_2d();
cd(fileparts(mfilename('fullpath')));

[X,P,X_arr,Q,F,H] = setX_P_Xarr_Q_F_2d(n,dt);

% fusion
for i = 1:n
    if (i == 1)
        y = getMeasurementData(signals,velocity,1,i);
        [X, P] = init_KF_2d(y);
    else
        [X, P] = prediction_2d(X, P, Q, F);
        [y, R] = getMeasurementData(signals,velocity,1,i);
        [X, P] = update_2d(X, P, y, R, H);
    end
    X_arr(i, :) = X;
    P_arr(i).M = P;
end
name = replace(mfilename,'_','\_');
plotResultsKF_2d(t,clean,signals,X_arr,velocity,[name]);
figure;
X_arr = rts_smooth(X_arr, P_arr, F, Q);
plotResultsKF_2d(t,clean,signals,X_arr,velocity,[name ' RTS']);
end
