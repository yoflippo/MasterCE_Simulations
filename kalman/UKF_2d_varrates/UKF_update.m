function [x, P] = UKF_update(z,R,x,P,sigmaPoints_f,weights,handleH)

sigmaPoints_H = handleH(sigmaPoints_f);
[uz,Pz] = UnscentedTransform(sigmaPoints_H,weights,R);

Pxz = zeros(length(x),length(z));
for i = 1:length(sigmaPoints_f)
    Pxz = Pxz + (weights.covariance(i) * (sigmaPoints_f(i,:)-x)'.*(sigmaPoints_H(i,:)-uz));
end

K = Pxz*inv(Pz);
x = x' + (K * (z'-uz)');
P = P - K*Pz*K';
x = x';
end