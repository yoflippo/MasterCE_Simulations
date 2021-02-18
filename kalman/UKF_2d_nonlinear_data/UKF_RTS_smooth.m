function [x_UKF, Ps] = UKF_RTS_smooth(x_UKF, Ps, Q, dt, weights)

for k = length(x_UKF)-1:-1:1
    sigmaPoints = MerweScaledSigmaPoints(x_UKF(k,:),Ps(k).M,weights);
    sigmas_F = UKF_f(sigmaPoints,dt);
    [xb,Pb] = UnscentedTransform(sigmas_F,weights,Q);
    Pxb = UKF_cross_variance(xb,x_UKF(k,:),weights,sigmas_F,sigmaPoints);
    K = Pxb * inv(Pb);
    x_UKF(k,:) = x_UKF(k,:) + (K * (x_UKF(k+1,:)-xb)')';
    Ps(k).M = Ps(k).M + ((K * (Ps(k+1).M - Pb)) * K');
end

end
