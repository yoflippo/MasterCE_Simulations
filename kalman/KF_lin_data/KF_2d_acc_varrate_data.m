function [] = KF_2d_acc_varrate_data()

[signals,velocity,clean,ts] = KF_INPUT_DATA_2d_data();
cd(fileparts(mfilename('fullpath')));

[X,P,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_data(ts);

% fusion
cnt = 1;
for i = 1:ts.n_v
    if i == 1
        y = getMeasurementData_data(signals,velocity,1,i);
        [X, P] = init_KF_2d_acc_data(y);
    else
        [X, P] = prediction_2d_acc_data(X, P, Q2, F2);
        [y, R] = getMeasurementData_data(signals,velocity,1,i);
        [X, P] = update_2d_acc_data(X, P, y, R, H2);
        
        if ts.t_p(cnt)<=ts.t_v(i)
%             [X, P] = prediction_2d_acc_data(X, P, Q1, F1);
            [y, R] = getMeasurementData_data(signals,velocity,1,cnt,true);
            [X, P] = update_2d_acc_data(X, P, y, R, H1);
            cnt = cnt + 1;
        end
    end
    X_kf(i,:) = X;
    P_kf(i).M = P;
    if cnt >= length(ts.t_p)
        break
    end
end
close all;
name = replace(mfilename,'_','\_');
plotResultsKF_2d_acc_data(ts,clean,signals,X_kf,velocity,[name]);
figure;
X_kf = rts_smooth(X_kf, P_kf, F2, Q2);
plotResultsKF_2d_acc_data(ts,clean,signals,X_kf,velocity,[name ' RTS']);
distFig
end

