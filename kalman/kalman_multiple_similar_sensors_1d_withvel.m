function [] = kalman_multiple_similar_sensors_1d_withvel()


[dt,t,n,signals,velocity,clean] = KF_INPUT_DATA();

X = zeros(2,1);% state matrix
P = zeros(2,2);% covariance matrix
X_arr = zeros(n, 2);% kalman filter output through the whole time

Q = [0.1 0;% system noise
    0 1]*1;
F = [1 dt;% transition matrix
    0 1];
H = [1 0;
    0 1];% observation matrix

% fusion
for i = 1:n
    if (i == 1)
        [X, P] = init_kalman(X, signals(1).sig(i, 1)); % initialize the state using the 1st sensor
    else
        [X, P] = prediction(X, P, Q, F);
        y = [signals(1).sig(i) velocity(1).sig(i)];
        R = [signals(1).var(i) 0; 0 velocity(1).var(i)];
        [X, P] = update(X, P, y, R, H);
    end
    X_arr(i, :) = X(1,:);
end

plotResultsKF(t,clean,signals,X_arr,'withvelocity');
legend();
end








