function [] = UKF_main_nonlinear()

[position,velocity,~,clean,ts] = UKF_create_simulation_data();
cd(fileparts(mfilename('fullpath')));

cnt = 1;
for i = 1:ts.n2
    if i == 1
        [z, R] = UKF_get_measurement_sample(position,velocity,1,i,1,true);
        [x, P] = UKF_init(z,R);
        weights = UKF_weights(length(x),0.1,2,1);
    end
    
    sigmaPoints = MerweScaledSigmaPoints(x,P,weights);
    [x, P,sigmaPoints_f] = UKF_predict(sigmaPoints,weights, @UKF_Q, @UKF_f, ts.dt2);
    [z, R] = UKF_get_measurement_sample(position,velocity,1,i,0);
    [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h_vel);
    
    if ts.t(cnt) <= ts.t2(i)
        [z, R] = UKF_get_measurement_sample(position,velocity,1,cnt,1);
        [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h_pos);
        cnt = cnt + 1;
    end
    
    UKF_x(i,:) = x;
    UKF_P(i).M = P;
    if cnt >= length(ts.t)
        break
    end
end

close all; name = replace(mfilename,'_','\_');
blVisiblePlots = 0;
RMSE1 = UKF_plot_results(ts,clean,position,UKF_x,velocity,[name],blVisiblePlots);

UKF_x = UKF_RTS_smooth(UKF_x, UKF_P, UKF_Q(ts.dt2),ts.dt2,weights);

RMSE2 = UKF_plot_results(ts,clean,position,UKF_x,velocity,[name ' RTS'],blVisiblePlots);
distFig
[RMSE1 RMSE2]
end

