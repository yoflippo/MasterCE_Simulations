function out = UKF_h_pos(priorSigmas)
% x / y / angle / rot.rate. / rot. acc. / Vres / Accres
out = priorSigmas(:,logical([1 1 0 0  0 0 0]));
end

