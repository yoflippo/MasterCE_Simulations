function [] = UKF_main_linear_variablerates()

[position,velocity,clean,acceleration,ts] = UKF_create_simulation_data();
cd(fileparts(mfilename('fullpath')));

% [x,P,X_kf,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(ts);
Q1 = [0.005 0.01 0 0;
    0.01 0.02 0 0;
    0 0 0.005 0.01;
    0 0 0.01 0.02;];

cnt = 1;
for i = 1:ts.n2
    if i == 1
%         z = UKF_get_measurement_sample(position,velocity,1,i,1);
        [x, P] = UKF_init();
    end
    
    weights = UKF_weights(length(x),0.1,2,1);
    sigmaPoints = MerweScaledSigmaPoints(x,P,weights);
    [x, P,sigmaPoints_f] = UKF_predict(sigmaPoints,weights, Q1, @UKF_f, ts.dt);
    [z, R] = UKF_get_measurement_sample(position,velocity,1,i,1);
    [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h);
    
    %         if ts.t(cnt)<=ts.t2(i)
    %             %             [X, P] = prediction_2d_acc_varrates(X, P, Q1, F1);
    %             [z, R] = UKF_get_measurement_sample(signals,velocity,1,cnt,true);
    %             [x, P] = update_2d_acc_varrates(x, P, z, R, H1);
    %             cnt = cnt + 1;
    %         end
    
    X_kf(i, :) = x;
    P_kf(i).M = P;
    if cnt >= length(ts.t)
        break
    end
    
end
close all;
name = replace(mfilename,'_','\_');
UKF_plot_results(ts,clean,position,X_kf,velocity,[name]);
% figure;
% X_kf = rts_smooth(X_kf, P_kf, F2, Q2);
% plotResultsUKF(ts,clean,signals,X_kf,velocity,[name ' RTS']);
distFig
end

