function [X,P,X_arr,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_varrates(n,dt,n2,dt2)
dim = 6;
X = zeros(dim,1);           % state matrix
P = eye(dim)*2;             % covariance matrix
X_arr = zeros(n, dim);      % kalman filter output through the whole time


% Q = [0.02      0   0       0   0   0;% system noise
%     0      0.05 0       0   0   0;
%     0      0   0.5    0   0   0;
%     0      0   0       0.02   0   0;
%     0      0   0       0   0.05 0;
%     0      0   0       0   0   0.5];
variance = 0.02;
Q1 = createQ(dt,variance);
Q2 = createQ(dt2,variance);


F = [1 dt 0.5*dt*dt 0 0 0;% transition matrix
    0 1  dt        0 0 0;
    0 0  1         0 0 0;
    0 0  0         1 dt 0.5*dt*dt;
    0 0  0         0 1  dt;
    0 0  0         0 0  1];

F2 = [1 dt2 0.5*dt*dt2 0 0 0;% transition matrix
    0 1  dt2        0 0 0;
    0 0  1         0 0 0;
    0 0  0         1 dt2 0.5*dt2*dt2;
    0 0  0         0 1  dt2;
    0 0  0         0 0  1];

H2 =[0 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 1 0;];% observation matrix

H1 =[1 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 0 0;];% observation matrix
end

function Q = createQ(dt,var)
Q = [.25*dt^4, .5*dt^3, .5*dt^2 0 0 0;
    .5*dt^3,    dt^2,       dt 0 0 0;
    .5*dt^2,       dt,        1 0 0 0;
    0          0       0       .25*dt^4, .5*dt^3, .5*dt^2;
    0          0       0       .5*dt^3,    dt^2,       dt ;
    0          0       0       .5*dt^2,       dt,        1]*var;
end
