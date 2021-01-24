function [x, P] = UKF_init(y)
% x(1:2) = y(1:2);
% x(3) = 0; 
% x(4:5) = y(3:4);
% x(6) = 0;
% P = eye(numel(x)).*ones(1,numel(x))*5;
% x = x';
x = zeros(1,4);
P = eye(numel(x)).*ones(1,numel(x))*1;
end