function Q = UKF_Q(dt,variance)
%% Calculate system noise
if not(exist('variance','var'))
    variance = 1;
end

Q = [1.0*dt       0     0.001           0      0   -0.01        0.001;
     0        1.0*dt    0.001        0      0   -0.01        0.001;
     0        0         dt^2        0.001  0   0        0;
     0        0         0           dt^2   0   0        0;
     0        0         0           0      0.2 0      0;
     0        0         0           0      0   dt^2     0;
     0        0         0           0      0   0        4]*variance;

Q = Q+triu(Q,-1).'; % make it symmetric
end

