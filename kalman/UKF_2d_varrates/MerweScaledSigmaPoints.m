function out = MerweScaledSigmaPoints(meanFilter,covFilter,alpha,beta,kappa)
n = numel(meanFilter);

if not(exist('alpha','var')) || isempty(alpha)
    alpha = 0.1; % 0 <= alpha <= 1, larger = more spread
end
if not(exist('beta','var')) || isempty(beta)
    beta = 2; % optimal for Gaussian, incorporate prior knowledge
end
if not(exist('kappa','var')) || isempty(kappa)
    kappa = 3-n;
end

Psig = eye(n)*covFilter;
[Wc,Wm,lambda] = UKF_compute_weights(n,alpha,beta,kappa);
U = chol((n+lambda)*Psig);
sigmaPoints(1,:) = meanFilter.*ones(1,n);

for i = 2:n+1
    sigmaPoints(i,:) = meanFilter + U(i-1,:);
    sigmaPoints(i+n,:) = meanFilter - U(i-1,:);
end

out.sigmaPoints = sigmaPoints;
out.WeightsCovariance = Wc;
out.WeightsMean = Wm;
out.lamda = lambda;
end