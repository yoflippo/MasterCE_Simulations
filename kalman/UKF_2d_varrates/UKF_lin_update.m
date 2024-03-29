function [x, P] = UKF_lin_update(z,R,x,P,sigmaPoints_F,weights,handleH)

sigmaPoints_H = handleH(sigmaPoints_F);
[uz,Pz] = UnscentedTransform(sigmaPoints_H,weights,R);

Pxz = UKF_lin_cross_variance(x,uz,weights,sigmaPoints_F,sigmaPoints_H);

K = Pxz*inv(Pz);
x = x + (K * (z'-uz)')';
P = P - K*Pz*K';
end