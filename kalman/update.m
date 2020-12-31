function [X, P] = update(X, P, y, R, H)
Inn = y' - H*X;
S = H*P*H' + R;
K = P*H'*inv(S);

X = X + K*Inn;
% P = P - K*H*P;
P = (eye(size(P))-K*H)*P*(eye(size(P))-K*H)' + K*R*K'; %joseph equation
end