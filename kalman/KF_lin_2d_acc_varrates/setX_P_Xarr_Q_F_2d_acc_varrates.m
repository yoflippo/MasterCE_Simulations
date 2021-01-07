function [X,P,X_arr,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(ts)
n = ts.n;   %POSITION
dt = ts.dt;

n2 = ts.n2; %VELOCITY
dt2 = ts.dt2;

dim = 6;
X = zeros(dim,1);           % state matrix
P = eye(dim)*2;             % covariance matrix
X_arr = zeros(n, dim);      % KF filter output through the whole time

% Q = [0.02      0   0       0   0   0;% system noise
%     0      0.05 0       0   0   0;
%     0      0   0.5    0   0   0;
%     0      0   0       0.02   0   0;
%     0      0   0       0   0.05 0;
%     0      0   0       0   0   0.5];

Q1 = createQ(dt, 100); %POSITION
Q2 = createQ(dt2,0.2); %VELOCITY


F1 = [1 dt 0.5*dt^2 0 0 0;% transition matrix
    0 1  dt        0 0 0;
    0 0  1         0 0 0;
    0 0  0         1 dt 0.5*dt^2;
    0 0  0         0 1  dt;
    0 0  0         0 0  1];

F2 = [1 dt2 0.5*dt2^2 0 0 0;% transition matrix VELOCITY
    0 1  dt2        0 0 0;
    0 0  1         0 0 0;
    0 0  0         1 dt2 0.5*dt2^2;
    0 0  0         0 1  dt2;
    0 0  0         0 0  1];

H1 =[1 0 0 0 0 0;
    0 0 0 1 0 0;];% observation matrix

H2 =[
    0 1 0 0 0 0;
    0 0 0 0 1 0;];% observation matrix
end

function Q = createQ(dt,var)
Q = [.25*dt^4, .5*dt^3, .5*dt^2 0 0 0;
    .5*dt^3,    dt^2,       dt 0 0 0;
    .5*dt^2,       dt,        1 0 0 0;
    0          0       0       .25*dt^4, .5*dt^3, .5*dt^2;
    0          0       0       .5*dt^3,    dt^2,       dt ;
    0          0       0       .5*dt^2,       dt,        1]*var;

% Q = [0.02      0   0       0   0   0;% system noise
%      0      0.05 0       0   0   0;
%      0      0   0.5    0   0   0;
%      0      0   0       0.02   0   0;
%      0      0   0       0   0.05 0;
%      0      0   0       0   0   0.5];
end
