function sigmaPoints = MerweScaledSigmaPoints(meanFilter,covFilter,weights)

n = numel(meanFilter);
Psig = eye(n)*covFilter;
U = chol((n+weights.lambda)*Psig);

[r,c] = size(meanFilter);
if r>c
    meanFilter = meanFilter';
end

sigmaPoints(1,:) = meanFilter;
for i = 2:n+1
    sigmaPoints(i,:) = meanFilter + U(i-1,:);
    sigmaPoints(i+n,:) = meanFilter - U(i-1,:);
end

end