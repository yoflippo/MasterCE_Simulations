function [x,P] = UnscentedTransform(sigmaPoints,weights,noiseMatrix)
x = weights.mean * sigmaPoints;

y = sigmaPoints - x;
alpha = 1; %% IDEA, use an alpha for specific state variables
P = (alpha^2)*(y' * (diag(weights.covariance) * y));

if not(exist('noiseMatrix','var'))
    noiseMatrix = zeros(size(P));
end
P = P + noiseMatrix;
end

