function Q = UKF_Q(dt,variance)
%% Calculate system noise
if not(exist('variance','var'))
    variance = 1;
end

posvar = 2;
Q = [posvar*dt  0         0  	  0       0        0         0;
     0          posvar*dt 0 	  0       0       0          0;
     0          0         dt^2	  0       0       0           0;
     0          0         0       dt^2    0       0           0;
     0          0         0       0       0.1     0           0;
     0          0         0       0       0       0.5*dt^2        0;
     0          0         0       0       0       0           1.5]*variance;

Q = Q+triu(Q,-1).'; % make it symmetric
end

