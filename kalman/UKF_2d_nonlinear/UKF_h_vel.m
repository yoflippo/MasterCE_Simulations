function out = UKF_h_vel(priorSigmas)
% x / y / angle / rot.rate. / rot. acc. / Vres / Accres
out = priorSigmas(:,logical([0 0 0 1 0 0 1 0]));
end

