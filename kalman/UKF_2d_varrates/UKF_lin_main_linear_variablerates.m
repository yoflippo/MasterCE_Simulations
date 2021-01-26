function [] = UKF_lin_main_linear_variablerates()

[position,velocity,clean,~,ts] = UKF_lin_create_simulation_data();
cd(fileparts(mfilename('fullpath')));

cnt = 1;
for i = 1:ts.n2
    if i == 1
        z = UKF_lin_get_measurement_sample(position,velocity,1,i,1);
        [x, P] = UKF_lin_init(z);
        weights = UKF_lin_weights(length(x));
    end
    
    sigmaPoints = MerweScaledSigmaPoints(x,P,weights);
    [x, P,sigmaPoints_f] = UKF_lin_predict(sigmaPoints,weights, @UKF_lin_Q, @UKF_lin_f, ts.dt2);
    [z, R] = UKF_lin_get_measurement_sample(position,velocity,1,i,0);
    [x, P] = UKF_lin_update(z,R,x,P,sigmaPoints_f,weights,@UKF_lin_h_vel);
    
    if ts.t(cnt) <= ts.t2(i)
        [z, R] = UKF_lin_get_measurement_sample(position,velocity,1,cnt,1);
        [x, P] = UKF_lin_update(z,R,x,P,sigmaPoints_f,weights,@UKF_lin_h_pos);
        cnt = cnt + 1;
    end
    
    UKF_x(i,:) = x;
    UKF_P(i).M = P;
    if cnt >= length(ts.t)
        break
    end
end

close all; name = replace(mfilename,'_','\_');
UKF_lin_plot_results(ts,clean,position,UKF_x,velocity,[name]);

UKF_x = UKF_lin_RTS_smooth(UKF_x, UKF_P, UKF_lin_Q(ts.dt2),ts.dt2,weights);
UKF_lin_plot_results(ts,clean,position,UKF_x,velocity,[name ' RTS']);
distFig
end

