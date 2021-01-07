function [X,P,X_arr,Q,F] = setX_P_Xarr_Q_F(n,dt)
X = zeros(2,1);% state matrix
P = zeros(2,2);% covariance matrix
X_arr = zeros(n, 2);% KF filter output through the whole time

Q = [0.1 0;% system noise
    0 1];
F = [1 dt;% transition matrix
    0 1];
end

