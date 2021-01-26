function out = UKF_f(sigmaPoints,dt)
for nR = 1:length(sigmaPoints)
   out(nR,:) = transitionMatrix(sigmaPoints(nR,:)',dt);
end
end

function F = transitionMatrix(sp,dt)
F(1) = sp(1)  +  sp(6) * cosd(sp(3)) * dt;
F(2) = sp(1)  +  sp(6) * sind(sp(3)) * dt;
F(3) = sp(3)  +  sp(4) * dt;
F(4) = sp(4)  +  sp(5) * dt;
F(5) = sp(5);
% F(6) = sp(6) ;
F(6) = sp(6)  +  sp(7) * dt;
F(7) = sp(7); 
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