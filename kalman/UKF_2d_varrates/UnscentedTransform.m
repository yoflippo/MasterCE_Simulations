function [x,P] = UnscentedTransform(sigmaPoints,weights,noiseMatrix)
x = weights.mean * sigmaPoints;

y = sigmaPoints - x;
P = y' * (diag(weights.covariance) * y);

if not(exist('noiseMatrix','var'))
    noiseMatrix = zeros(size(P));
end
P = P + noiseMatrix;
end

