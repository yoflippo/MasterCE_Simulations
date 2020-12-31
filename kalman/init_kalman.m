function [X, P] = init_kalman(X, y)
X(1,1) = y;
X(2,1) = 0;

P = [10 0;
    0   30];
end