function Q = UKF_Q(dt,variance)
%% Calculate system noise

if not(exist('variance','var'))
    variance = 1;
end


% Q = [.25*dt^4, .5*dt^3, .5*dt^2 0 0 0;
%     .5*dt^3,    dt^2,       dt 0 0 0;
%     .5*dt^2,       dt,        1 0 0 0;
%     0          0       0       .25*dt^4, .5*dt^3, .5*dt^2;
%     0          0       0       .5*dt^3,    dt^2,       dt ;
%     0          0       0       .5*dt^2,       dt,        1]*variance;

% Q = [0.3*dt^4 1         dt       0      0   dt          dt; 
%      0        0.3*dt^4  dt       0      0   dt          dt;
%      0        0         0.5*dt^3 dt     1   0           0;
%      0        0         0        dt     0   0           0;
%      0        0         0        0      1   0           0;
%      0        0         0        0      0   0.5*dt^2    0;
%      0        0         0        0      0   0           1]*variance;

Q = [dt       0         0.005    0      0   -0.01        0.01;
     0        dt        0.05     0      0   -0.01        0.01;
     0        0         0.1      0      0   0           0;
     0        0         0        dt^2   0   0           0;
     0        0         0        0      3   0           0;
     0        0         0        0      0   dt^2        0.01;
     0        0         0        0      0   0           3]*variance;

% Q = [0.3*dt^4 1         dt       0      0   dt          ;
%      0        0.3*dt^4  dt       0      0   dt          ;
%      0        0         0.5*dt^3 dt     1   0           ;
%      0        0         0        dt     0   0           ;
%      0        0         0        0      1   0           ;
%      0        0         0        0      0   0.5*dt^2    ;]*variance;

Q = Q+triu(Q,-1).'; % make it symmetric
end

