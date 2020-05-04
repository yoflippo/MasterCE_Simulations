function [sols,res] = solver_optmultlat(s,d,w)
% Finds all stationary points to
% min_(x,o) sum_j w(j) * (|x-s(:,k)|^2 - (d(k)+o)^2)^2

n = size(s,1);
d = d(:);
if nargin < 3 || isempty(w)
    w = 1./d.^2;
end
% Normalize weights
w = w / sum(w);

Q = diag([ones(1,n) -1]);

% Residuals are 
% x'*Q*x + cc(:,i)'*x + dd(i)
cc = 2*[-s; d'];
dd = [-d.^2 + sum(s.^2,1)'];

% shift center
t = -inv(Q)*sum(cc .* w(:,ones(1,n+1))',2)/2;

dd = dd + (t'*Q*t + cc'*t);
cc = cc + 2*Q*t*ones(1,size(cc,2));


% Construct A,b such that (x'*Q*x)*Q*x + A*x + b = 0
ws2md2 = w.*dd;
A = (cc .* w(:,ones(n+1,1)).') * cc.' + 2 * sum(ws2md2) * Q;
b = cc*ws2md2;
A = A / 2;
b = b / 2;

A = inv(Q)*A;
b = inv(Q)*b;

n = n +1;


% ind = nchoosek(1:n,2);
% mul_ind = [];
% for k = 1:n
%     % where does [x1,x2,..,xn,1] go when we multiply by xk
%     tmp = zeros(1,n+1);
%     for i = 1:n
%         if k == i
%             tmp(i) = length(ind) + i;
%         else
%             tt = sort([i k]);
%             tmp(i) = find(ismember(ind,tt,'rows'));
%         end
%     end
%     tmp(end) = length(ind) + n + k;
%     mul_ind(k,:) = tmp;
% end
if n == 4
    mul_ind = [7,1,2,3,11;1,8,4,5,12;2,4,9,6,13;3,5,6,10,14];
    ind = [1,2;1,3;1,4;2,3;2,4;3,4];
elseif n == 3
    mul_ind = [4,1,2,7;1,5,3,8;2,3,6,9];
    ind = [1,2;1,3;2,3];
elseif n == 2
    mul_ind = [3,1,5;1,4,6];
    ind = [1,2];
else
    error('NYI');
end

AA = [];
for k = 1:size(ind,1)
    i = ind(k,1); j= ind(k,2);

    tmp = zeros(1,length(ind)+n+n+1);

    tmp(mul_ind(i,:)) = [A(j,:) b(j)];
    tmp(mul_ind(j,:)) = tmp(mul_ind(j,:)) - [A(i,:) b(i)];
    AA(k,:) = tmp;
end

% [xy,xz,yz,x2,y2,z2,x,y,z,1]

BB = -AA(:,1:length(ind)) \ AA(:,length(ind)+1:end);
D = diag(diag(A));

% basis = [x^2,y^2,z^2,x,y,z,1]
AM = [-D diag(-b) zeros(n,1);
     zeros(n,n) -A -b;
     ones(1,n-1) -1 zeros(1,n+1)];

% Eliminate mixed terms
for k = 1:n
    for i = 1:n
        if k == i
            continue;
        end
        AM(k,:) = AM(k,:) - A(k,i) * BB(mul_ind(k,i),:);
    end
end

[VV,DD] = eig(AM);
VV = VV ./ (ones(2*n+1,1)*VV(end,:));
r = VV(n+1:2*n,:);
sols = r + t*ones(1,size(r,2));
if nargout == 2
    lambda = diag(DD);
    res = [];
    for k = 1:2*n+1
        rk = r(:,k);
        lambdak = lambda(k);
        res(:,k) = [(rk.'*Q*rk)*rk + A*rk + b; lambdak - rk.'*Q*rk];
    end
end

