function [] = KF_lin_2d_acc_sepsens()

[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA_2d();
cd(fileparts(mfilename('fullpath')));

[X,P,X_arr,Q,F,Hp,Hv] = setX_P_Xarr_Q_F_2d_acc_sepsens(n,dt);

% fusion
for i = 1:n
    if (i == 1)
        y = getMeasurementData(signals,velocity,1,i);
        [X, P] = init_KF_2d_acc_sepsens(y);
    else
        [X, P] = prediction_2d_acc_sepsens(X, P, Q, F);
        [y, R] = getMeasurementData_acc_sepsens(signals,velocity,1,i,true);
        [X, P] = update_2d_acc(X, P, y, R, Hp);
        [y, R] = getMeasurementData_acc_sepsens(signals,velocity,1,i);
        [X, P] = update_2d_acc(X, P, y, R, Hv);
    end
    X_arr(i, :) = X;
    P_arr(i).M = P;
end
name = replace(mfilename,'_','\_');
plotResultsKF_2d_acc_sepsens(t,clean,signals,X_arr,velocity,name);
figure;
[X_arr, P, K, Pp] = rts_smooth(X_arr, P_arr, F, Q);
plotResultsKF_2d_acc_sepsens(t,clean,signals,X_arr,velocity,[name ' RTS']);
end

