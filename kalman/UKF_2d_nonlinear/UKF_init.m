function [x, P] = UKF_init(z,R)
R1 = diag(R);
% see UKF_get_measurement_sample()
x(1) = z(1); r(1) = R1(1);
x(2) = z(2); r(2) = R1(2);
x(3) = z(5); r(3) = R1(5);  % angle
x(4) = z(4); r(4) = R1(4);  % angular rate
x(5) = 0;    r(5) = 10;     % angular acceleration
x(6) = z(3); r(6) = R1(3);  % velocity
x(7) = 0;    r(7) = 10;     % acceleration
% P = eye(numel(x)).*r;
P = eye(numel(x)).*2;
end