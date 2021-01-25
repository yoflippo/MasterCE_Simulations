function [X,P,Q1,Q2,F1,F2,H1,H2] = setX_P_Xarr_Q_F_2d_acc_data(ts)
n = ts.n_p;   %POSITION
dt = ts.dt_p;

n2 = ts.n_v; %VELOCITY
dt2 = ts.dt_v;

dim = 6;
X = zeros(dim,1);           % state matrix
P = eye(dim)*2;             % covariance matrix

% Q = [0.02      0   0       0   0   0;% system noise
%     0      0.05 0       0   0   0;
%     0      0   0.5    0   0   0;
%     0      0   0       0.02   0   0;
%     0      0   0       0   0.05 0;
%     0      0   0       0   0   0.5];

Q1 = createQ(dt, 100); %POSITION
Q2 = createQ(dt2,10); %VELOCITY


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
% Q = [.25*dt^4, .5*dt^3, .5*dt^2 0 0 0;
%     .5*dt^3,    dt^2,       dt 0 0 0;
%     .5*dt^2,       dt,        1 0 0 0;
%     0          0       0       .25*dt^4, .5*dt^3, .5*dt^2;
%     0          0       0       .5*dt^3,    dt^2,       dt ;
%     0          0       0       .5*dt^2,       dt,        1]*var;

Q = [0.1      0   0       0   0   0;% system noise
     0      0.1 0       0   0   0;
     0      0   5    0   0   0;
     0      0   0       0.1   0   0;
     0      0   0       0   0.1 0;
     0      0   0       0   0   5];
end
