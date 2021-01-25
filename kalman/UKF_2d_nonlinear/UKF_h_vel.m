function out = UKF_h_vel(priorSigmas)
H1 = logical([0 1 0 0 1 0]);
out = priorSigmas(:,H1);
end

