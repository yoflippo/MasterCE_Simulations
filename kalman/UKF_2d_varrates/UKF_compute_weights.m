function [Wc,Wm,lambda] = UKF_compute_weights(n,alpha,beta,kappa)

lambda = (alpha^2)*(n+kappa)-n;

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
end