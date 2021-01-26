function out = UKF_lin_f(sigmaPoints,dt)
for nR = 1:length(sigmaPoints)
   out(nR,:) = transitionMatrix(sigmaPoints(nR,:)',dt);
end
end

function F = transitionMatrix(sp,dt)
F(1) = sp(1) + sp(2)*dt + sp(3)*0.5*dt^2;
F(2) =         sp(2)    + sp(3)*dt;
F(3) =                  + sp(3);
F(4) = 0       + 0        + 0               + sp(4) + sp(5)*dt + sp(6)*0.5*dt^2;
F(5) = 0       + 0        + 0               +         sp(5)    + sp(6)*dt;
F(6) = 0       + 0        + 0               +                  + sp(6); 
end


% % % % F = [1 dt 0.5*dt^2 0 0 0;% transition matrix
% % % %     0 1  dt        0 0 0;
% % % %     0 0  1         0 0 0;
% % % %     0 0  0         1 dt 0.5*dt^2;
% % % %     0 0  0         0 1  dt;
% % % %     0 0  0         0 0  1];
% % % % 
% % % % for nR = 1:length(sigmaPoints)
% % % %    out(nR,:) = F * sigmaPoints(nR,:)';
% % % % end