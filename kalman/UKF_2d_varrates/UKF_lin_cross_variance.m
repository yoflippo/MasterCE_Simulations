function Pxz = UKF_lin_cross_variance(x,uz,weights,sigmaPoints_F,sigmaPoints_H)
Pxz = zeros(length(x),length(uz));
for i = 1:length(sigmaPoints_F)
    Pxz = Pxz + (weights.covariance(i) * (sigmaPoints_F(i,:)-x)'.*(sigmaPoints_H(i,:)-uz));
end
end

