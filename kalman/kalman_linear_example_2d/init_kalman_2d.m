function [X, P] = init_kalman_2d(y)
X = y;
P = eye(numel(X)).*ones(1,numel(X))*5;
end