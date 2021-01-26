function [xs, Ps] = UKF_lin_RTS_smooth(x_UKF, Ps, Q, dt, weights)

xs = x_UKF;
for k = length(xs)-1:-1:1
    sigmaPoints = MerweScaledSigmaPoints(xs(k,:),Ps(k).M,weights);
    sigmas_F = UKF_lin_f(sigmaPoints,dt);
    [xb,Pb] = UnscentedTransform(sigmas_F,weights,Q);
    Pxb = UKF_lin_cross_variance(xb,xs(k,:),weights,sigmas_F,sigmaPoints);
    K = Pxb * inv(Pb);
    xs(k,:) = xs(k,:) + (K * (xs(k+1,:)-xb)')';
    Ps(k).M = Ps(k).M + ((K * (Ps(k+1).M - Pb)) * K');
end

end