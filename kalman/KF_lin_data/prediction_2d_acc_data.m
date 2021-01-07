function [X, P] = prediction_2d_acc_data(X, P, Q, F)
X = F*X;
P = F*P*F' + Q;
end