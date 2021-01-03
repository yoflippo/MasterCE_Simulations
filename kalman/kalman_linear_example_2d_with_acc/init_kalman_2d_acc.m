function [X, P] = init_kalman_2d_acc(y)
X = y;
X(3) = 1e-2; X(6) = 1e-2;
P = eye(numel(y)).*ones(1,numel(y));
end