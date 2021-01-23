function out = UKF_h(priorSigmas)
% pass prior sigmas through h(x) to get measurement sigmas
% the shape of sigmas_h will vary if the shape of z varies, so
% recreate each time

% H1 =[1 0 0 0 0 0;
%     0 0 0 1 0 0;];% observation matrix
out = [priorSigmas(1,1) priorSigmas(2,4)];
end

