function [] = kalman_multiple_similar_sensors()
close all;
dt = 0.1;% time step
t=(0:dt:20)';
n = numel(t);
signal = 1*sin(t*5)+t;%ground truth
X = zeros(2,1);% state matrix
P = zeros(2,2);% covariance matrix
X_arr = zeros(n, 2);% kalman filter output through the whole time
Q = [0.1 0;% system noise
    0 1]*1;
F = [1 dt;% transition matrix
    0 1];
H = [1 0];% observation matrix

s1_var = 0.1*ones(size(t));
s1 = generate_signal(signal, s1_var);
s2_var = 0.1*(cos(8*t)+10*t);
s2 = generate_signal(signal, s2_var);
s3_var = 0.1*(sin(2*t)+10);
s3 = generate_signal(signal, s3_var);
s4_var = 0.1*ones(size(t));
s4 = generate_signal(signal, s4_var);

% fusion
for i = 1:n
    if (i == 1)
        [X, P] = init_kalman(X, s1(i, 1)); % initialize the state using the 1st sensor
    else
        [X, P] = prediction(X, P, Q, F);
        [X, P] = update(X, P, s1(i, 1), s1(i, 2), H);
        [X, P] = update(X, P, s2(i, 1), s2(i, 2), H);
        [X, P] = update(X, P, s3(i, 1), s3(i, 2), H);
        [X, P] = update(X, P, s4(i, 1), s4(i, 2), H);
    end
%     hold on; draw2DCovarianceEllipse(P/50,[t(i) signal(i)]);
    X_arr(i, :) = X;
end

plot(t, signal, 'LineWidth', 2);
hold on;
plot(t, s1(:, 1), '--', 'LineWidth', 1);
plot(t, s2(:, 1), '--', 'LineWidth', 1);
plot(t, s3(:, 1), '--', 'LineWidth', 1);
plot(t, s4(:, 1), '--', 'LineWidth', 1);
plot(t, X_arr(:, 1), 'LineWidth', 2);
title(num2str(round(rmse(X_arr(:,1)-signal),3)))
hold off;
grid on;
% legend('Ground Truth', 'Sensor Input 1', 'Sensor Input 2', 'Sensor Input 3', 'Sensor Input 4', 'Fused Output');
end


function [s] = generate_signal(signal, var)
noise = randn(size(signal)).*sqrt(var);
s(:, 1) = signal + noise;
s(:, 2) = var;
end

function [X, P] = init_kalman(X, y)
X(1,1) = y;
X(2,1) = 0;

P = [10 0;
    0   30];
end

function [X, P] = prediction(X, P, Q, F)
X = F*X;
P = F*P*F' + Q;
end

function [X, P] = update(X, P, y, R, H)
Inn = y - H*X;
S = H*P*H' + R;
% K = P*H'/S;
K = P*H'*inv(S);

X = X + K*Inn;
P1 = P - K*H*P;
P = (eye(size(P))-K*H)*P*(eye(size(P))-K*H)' + K*R*K'; %joseph equation
end