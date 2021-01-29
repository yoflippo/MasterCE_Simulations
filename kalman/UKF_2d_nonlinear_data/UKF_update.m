function [x, P, Residuals] = UKF_update(z,R,x,P,sigmaPoints_F,weights,handleH)

sigmaPoints_H = handleH(sigmaPoints_F);
[uz,Pz] = UnscentedTransform(sigmaPoints_H,weights,R);

Pxz = UKF_cross_variance(x,uz,weights,sigmaPoints_F,sigmaPoints_H);

K = Pxz * inv(Pz);
Residuals = (z'-uz)';
x = x + (K*Residuals)';
P = P - K*Pz*K';
end