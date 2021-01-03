function [X,P,X_arr,Q,F] = setX_P_Xarr_Q_F_2d(n,dt)
dim = 4;
X = zeros(dim,1);% state matrix
P = eye(dim)*2;% covariance matrix
X_arr = zeros(n, dim);% kalman filter output through the whole time

Q = [0.1 0 0 0;% system noise
    0 0.05 0 0;
    0 0 0.01 0;
    0 0 0 0.01];
F = [1 dt 0 0;% transition matrix
    0 1 0 0;
    0 0 1 dt;
    0 0 0 1];
end

