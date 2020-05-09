function distanceWithNoise = createNoise(distances)

[r,c] = size(distances);
distanceWithNoise = distances+randn(r,c);