function distanceWithNoise = addGaussianNoise(distances,factor)
if ~exist('factor','var')
    factor = 1;
end
[r,c] = size(distances);
distanceWithNoise = distances+(factor*randn(r,c));