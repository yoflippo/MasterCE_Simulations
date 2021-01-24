function out = UKF_f(sigmaPoints,dt)
% 
% F = [1 dt 0.5*dt^2 0 0 0;% transition matrix
%     0 1  dt        0 0 0;
%     0 0  1         0 0 0;
%     0 0  0         1 dt 0.5*dt^2;
%     0 0  0         0 1  dt;
%     0 0  0         0 0  1];

F = [1 dt  0 0 ;% transition matrix
    0 1    0 0;
    0 0    1 dt ;
    0 0    0 1 ];

out = sigmaPoints * F;
[r,c] = size(sigmaPoints);
for nR = 1:r
   out(nR,:) = F * sigmaPoints(nR,:)';
end
end

