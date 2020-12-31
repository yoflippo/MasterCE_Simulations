function [] = kalman_multiple_similar_sensors_1d()


[dt,t,n,signals,~,clean] = KF_INPUT_DATA();

X = zeros(2,1);% state matrix
P = zeros(2,2);% covariance matrix
X_arr = zeros(n, 2);% kalman filter output through the whole time

Q = [0.1 0;% system noise
    0 1]*1;
F = [1 dt;% transition matrix
    0 1];
H = [1 0];% observation matrix


% fusion
for i = 1:n
    if (i == 1)
        [X, P] = init_kalman(X, signals(1).sig(i, 1)); % initialize the state using the 1st sensor
    else
        [X, P] = prediction(X, P, Q, F);
        [X, P] = update(X, P, signals(1).sig(i), signals(1).var(i), H);
%         [X, P] = update(X, P, signals(2).sig(i), signals(2).var(i), H);
        [X, P] = update(X, P, signals(3).sig(i), signals(3).var(i), H);
%         [X, P] = update(X, P, signals(4).sig(i), signals(4).var(i), H);
    end
%     hold on; draw2DCovarianceEllipse(P/50,[t(i) signal(i)]);
    X_arr(i, :) = X;
end

plotResultsKF(t,clean,signals,X_arr,'novelocity');
% plot(t, signals(2).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 2')
plot(t, signals(3).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 3')
% plot(t, signals(4).sig(:), '--', 'LineWidth', 1,'DisplayName','measurement signal 4')
legend();
end
