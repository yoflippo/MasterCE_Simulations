function [] = UKF_main_linear_variablerates()

[position,velocity,clean,acceleration,ts] = UKF_create_simulation_data();
cd(fileparts(mfilename('fullpath')));

% [x,P,X_kf,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(ts);

cnt = 1;
for i = 1:ts.n2
    if i == 1
        z = UKF_get_measurement_sample(position,velocity,1,i,1);
        [x, P] = UKF_init(z);
        weights = UKF_weights(length(x),0.1,2,1);
    end
    
    sigmaPoints = MerweScaledSigmaPoints(x,P,weights);
    [x, P,sigmaPoints_f] = UKF_predict(sigmaPoints,weights, UKF_Q(ts.dt2), @UKF_f, ts.dt2);
    [z, R] = UKF_get_measurement_sample(position,velocity,1,i,0);
    [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h_vel);
    
    if ts.t(cnt) <= ts.t2(i)
        [z, R] = UKF_get_measurement_sample(position,velocity,1,cnt,1);
        [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h_pos);
        cnt = cnt + 1;
    end
    
    x_UKF(i, :) = x;
    P_UKF(i).M = P;
    if cnt >= length(ts.t)
        break
    end
    
end
close all;
name = replace(mfilename,'_','\_');
figure;
UKF_plot_results(ts,clean,position,x_UKF,velocity,[name]);

% figure;
% x_UKF = UKF_RTS_smooth(x_UKF, P_UKF, @UKF_f, UKF_Q(ts.dt2));
% plotResultsUKF(ts,clean,signals,x_UKF,velocity,[name ' RTS']);

distFig
end

