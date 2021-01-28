function Q = UKF_Q(dt,variance)
%% Calculate system noise
if not(exist('variance','var'))
    variance = 0.5;
end

posvar = 1.2;
Q = [posvar*dt  -0.002         0.007	  0      0        -0.01        0.0001;
     0          posvar*dt 0.007	  0       0       -0.01        0.0001;
     0          0         dt^2	  0.001   0       0           0;
     0          0         0       dt^2    -0.16       0           0;
     0          0         0       0       0.2     0           0;
     0          0         0       0       0       dt^2        0;
     0          0         0       0       0       0           2]*variance;

Q = Q+triu(Q,-1).'; % make it symmetric
end

