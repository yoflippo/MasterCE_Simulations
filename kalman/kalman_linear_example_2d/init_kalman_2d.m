function [X, P] = init_kalman_2d(y)
X = y;
P = eye(4).*[1; 1; 1; 1]*5;
end