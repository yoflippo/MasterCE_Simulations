function distanceWithNoise = createUWBNoise(distances,percentage)
%% Work in Progress
if percentage > 1
    percentage = percentage / 100;
end

% More distance means more noise
[r,c] = size(distances);
distanceWithNoise = zeros(r,c);
for nR = 1:r
    for nC = 1:c
        currentDistance = distances(nR,nC);
        normalFactor = (currentDistance*percentage)/3;
        noise = normalFactor*randn(1,1); 
        distanceWithNoise(nR,nC) = currentDistance +  noise;
    end
end