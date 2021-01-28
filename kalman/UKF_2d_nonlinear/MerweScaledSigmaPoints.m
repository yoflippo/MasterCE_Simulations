function sigmaPoints = MerweScaledSigmaPoints(meanFilter,covFilter,weights)

n = numel(meanFilter);
P = eye(n)*covFilter;
sqrtMerwe = (n+weights.lambda) * P;

[r,c] = size(meanFilter);
if r>c
    meanFilter = meanFilter';
end

    sigmaPoints(1,:) = meanFilter;
try
    U = chol(sqrtMerwe);
    for i = 2:n+1
        sigmaPoints(i,:) = meanFilter + U(i-1,:);
        sigmaPoints(i+n,:) = meanFilter - U(i-1,:);
    end
catch
    warning([mfilename ' chol() not working']);
    for i = 2:n+1
        tmpMrw = sqrt(sqrtMerwe(i-1,:));
        sigmaPoints(i,:) = meanFilter + tmpMrw;
        sigmaPoints(i+n,:) = meanFilter - tmpMrw;
    end
end
end