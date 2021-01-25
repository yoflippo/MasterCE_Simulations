function Q = UKF_Q(dt,variance)

if not(exist('variance','var'))
    variance = 1;
end


Q = [.25*dt^4, .5*dt^3, .5*dt^2 0 0 0;
    .5*dt^3,    dt^2,       dt 0 0 0;
    .5*dt^2,       dt,        1 0 0 0;
    0          0       0       .25*dt^4, .5*dt^3, .5*dt^2;
    0          0       0       .5*dt^3,    dt^2,       dt ;
    0          0       0       .5*dt^2,       dt,        1]*variance;

% Q = [0.02      0   0       0   0   0;% system noise
%      0      0.05 0       0   0   0;
%      0      0   0.5    0   0   0;
%      0      0   0       0.02   0   0;
%      0      0   0       0   0.05 0;
%      0      0   0       0   0   0.5];

end

