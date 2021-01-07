function [X, P] = prediction_2d_acc_varrates(X, P, Q, F)
X = F*X;
P = F*P*F' + Q;
end