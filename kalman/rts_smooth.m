function [x, P, K, Pp] = rts_smooth(Xs, Ps, F, Q)
x = Xs;
P = Ps;
Pp = Ps;
for k = length(Xs)-1:-1:1
    Pp(k).M = F*P(k).M*F' + Q;
    K(k).M = P(k).M*F'*inv(Pp(k).M);
    x(k,:) = x(k,:) + (K(k).M*(x(k+1,:)-(F*x(k,:)')')')';
    P(k).M = P(k).M + (K(k).M * (P(k+1).M-Pp(k).M) * K(k).M');
end
end

% def rts_smoother(Xs, Ps, F, Q):
%     n, dim_x, _ = Xs.shape
% 
%     # smoother gain
%     K = zeros((n,dim_x, dim_x))
%     x, P, Pp = Xs.copy(), Ps.copy(), Ps.copy
% 
%     for k in range(n-2,-1,-1):
%         Pp[k] = F @ P[k] @ F.T + Q # predicted covariance
% 
%         K[k]  = P[k] @ F.T @inv(Pp[k])
%         x[k] += K[k] @ (x[k+1] - (F @ x[k]))     
%         P[k] += K[k] @ (P[k+1] - Pp[k]) @ K[k].T
%     return (x, P, K, Pp)