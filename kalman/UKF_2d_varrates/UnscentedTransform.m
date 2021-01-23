function [x,P] = UnscentedTransform(sigmaPoints,weights,noiseMatrix)
[~,n] = size(sigmaPoints);

x = weights.mean * sigmaPoints;
P = zeros(n,n);

y = sigmaPoints - x;
P = y' * (diag(weights.covariance) * y);

if not(exist('noiseMatrix','var'))
    noiseMatrix = zeros(size(P));
end
P = P + noiseMatrix;
end

