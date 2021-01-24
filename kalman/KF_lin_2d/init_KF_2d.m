function [X, P] = init_KF_2d(y)
X = y;
X(3) = X(2);
X(2) = 0;
X(4) = 0;
P = eye(numel(X)).*ones(1,numel(X))*1;
end