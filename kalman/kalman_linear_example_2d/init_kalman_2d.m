function [X, P] = init_kalman_2d(X, y)
X = y;
P = eye(4).*[1; 1; 1; 1];
end