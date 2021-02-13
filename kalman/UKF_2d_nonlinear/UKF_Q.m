function Q = UKF_Q(dt,variance)
%% Calculate system noise
if not(exist('variance','var'))
    variance = 1;
end

posvar = 2;
Q = [posvar*dt  0.00    0  	  0       0       0.00       0.000;
     0          posvar*dt 0 	  0       0       0.00       0.000;
     0          0         dt^1	  0       0       0           0;
     0          0         0       dt^2    0       0           0;
     0          0         0       0       0.1     0           0;
     0          0         0       0       0       0.1*dt^2    0;
     0          0         0       0       0       0           1]*variance;

Q = Q+triu(Q,-1).'; % make it symmetric
end




% function Q = UKF_Q(dt,variance)
% %% Calculate system noise
% if not(exist('variance','var'))
%     variance = 20;
% end
% 
% posvar = 10;
% Q = [posvar*dt  0         0 	  0      0        0        0;
%      0          posvar*dt 0   	  0       0       0        0;
%      0          0         dt^2	  0      0       0           0;
%      0          0         0       dt^2    0      0           0;
%      0          0         0       0       0.2     0           0;
%      0          0         0       0       0       10*dt^2        0;
%      0          0         0       0       0       0           2]*variance;
% 
% Q = Q+triu(Q,-1).'; % make it symmetric
% end

