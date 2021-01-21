function [] = UKF_2d_varrates()

[signals,velocity,clean,acceleration,ts] = datagen_UKF_2d_varrates();
cd(fileparts(mfilename('fullpath')));

[X,P,X_kf,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(ts);

% fusion
cnt = 1;
for i = 1:ts.n2
    if i == 1
        y = getMeasurementData_varrates(signals,velocity,1,i);
        [X, P] = init_UKF(y);
    else
        [X, P] = prediction_2d_acc_varrates(X, P, Q2, F2);
        [y, R] = getMeasurementData_varrates(signals,velocity,1,i);
        [X, P] = update_2d_acc_varrates(X, P, y, R, H2);
        
        if ts.t(cnt)<=ts.t2(i)
            %             [X, P] = prediction_2d_acc_varrates(X, P, Q1, F1);
            [y, R] = getMeasurementData_varrates(signals,velocity,1,cnt,true);
            [X, P] = update_2d_acc_varrates(X, P, y, R, H1);
            cnt = cnt + 1;
        end
    end
    X_kf(i, :) = X;
    P_kf(i).M = P;
    if cnt >= length(ts.t)
        break
    end
end
close all;
name = replace(mfilename,'_','\_');
plotResultsUKF(ts,clean,signals,X_kf,velocity,[name]);
% figure;
% X_kf = rts_smooth(X_kf, P_kf, F2, Q2);
% plotResultsUKF(ts,clean,signals,X_kf,velocity,[name ' RTS']);
distFig
end

