function out = UKF_h_pos(priorSigmas)
H1 =logical([1 0 0 1 0 0]);
out = priorSigmas(:,H1);
end

