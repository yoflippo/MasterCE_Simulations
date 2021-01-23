function [x,P] = UnscentedTransform(sigmaPoints,Wm,Wc,Q)
[~,n] = size(sigmaPoints);

x = Wm * sigmaPoints;
P = zeros(n,n);

y = sigmaPoints - x;
P = y' * (diag(Wc) * y);

if not(exist('Q','var'))
    Q = zeros(size(P));
end
P = P + Q;
end

