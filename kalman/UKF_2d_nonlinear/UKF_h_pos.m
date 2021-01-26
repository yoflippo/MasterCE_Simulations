function out = UKF_h_pos(priorSigmas)
out = priorSigmas(:,logical([1 1 0 0 0 0 0]));
end

