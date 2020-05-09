
function noise = createNoiseForMatrices(r,blDistNormal)
maxNumberOfExpectedColumns = 15;
range = 20; % cm
normalFactor = range/3;
for nC = 1:maxNumberOfExpectedColumns
    if blDistNormal
        % normally distributed
        noise{nC} = normalFactor*randn(r,nC); 
    else
        % uniformly distributed
        noise{nC} = -range + (2*range)*rand(r,nC);
    end
end
end