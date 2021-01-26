function weights = UKF_lin_weights(n,alpha,beta,kappa)

if not(exist('alpha','var')) || isempty(alpha)
    alpha = 0.1; % 0 <= alpha <= 1, larger = more spread
end
if not(exist('beta','var')) || isempty(beta)
    beta = 2; % optimal for Gaussian, incorporate prior knowledge
end
if not(exist('kappa','var')) || isempty(kappa)
    kappa = 3-n;
end

lambda = ((alpha^2)*(n+kappa))-n;

Wm(1) = lambda/(n+lambda); %Weight mean
Wc(1) = Wm(1) + (1-alpha^2 + beta); %Weight covariance (P)
Wc = restOfSigmaPoints(n,lambda,Wc);
Wm = [Wm Wc(2:end)];

    function Wc = restOfSigmaPoints(n,lambda,WcZero)
        Wc = WcZero;
        for nI = 2:(2*n)+1
            Wc(nI) = 1/(2*(n+lambda));
        end
    end

weights.covariance = Wc;
weights.mean = Wm;
weights.lambda = lambda;
end