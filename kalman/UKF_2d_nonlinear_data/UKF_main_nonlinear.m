function [UKF_RTS_x,errors] = UKF_main_nonlinear(ap)

if not(exist('ap','var'))
    ap = [];
    blVisiblePlots = 1;
    close all;
else
    blVisiblePlots = 0;
end

[position,velocity,clean,ts] = UKF_REAL_DATA(ap);
cd(fileparts(mfilename('fullpath')));

tVelocity = ts.t2;
tPosition = ts.t;

cnt = 1;
for i = 1:length(tVelocity)-1
    if i == 1
        [z, R] = UKF_get_measurement_sample(position,velocity,[],i,1,true);
        [x, P] = UKF_init(z,R);
        weights = UKF_weights(length(x),0.1,2,4);
    else
        sigmaPoints = MerweScaledSigmaPoints(x,P,weights);
        [x, P,sigmaPoints_f] = UKF_predict(sigmaPoints,weights, @UKF_Q, @UKF_f, tVelocity(i+1)-tVelocity(i));
        [z, R] = UKF_get_measurement_sample(position,velocity,[],i,0);
        [x, P, residualsV(i,:)] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h_vel);
        
        if tPosition(cnt) <= tVelocity(i)
            [z, R] = UKF_get_measurement_sample(position,velocity,[],cnt,1);
            [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,@UKF_h_pos);
            cnt = cnt + 1;
        end
    end
    
    UKF_x(i,:) = x;
    UKF_P(i).M = P;
    if cnt > length(tPosition)
        break
    end
end

UKF_RTS_x = UKF_RTS_smooth(UKF_x, UKF_P, UKF_Q(ts.dt2),ts.dt2,weights);

name = replace(mfilename,'_','\_');
RMSE1 = UKF_plot_results_data(ts,clean,position,UKF_x,velocity,[name],blVisiblePlots);
[RMSE2, RMSERAW] = UKF_plot_results_data(ts,clean,position,UKF_RTS_x,velocity,[name ' RTS'],blVisiblePlots);
distFig; 
errors = [RMSE1 RMSE2 RMSERAW ((RMSE2-RMSERAW)/RMSERAW)];
% UKF_plot_residuals(position,residualsV,UKF_RTS_x)
end