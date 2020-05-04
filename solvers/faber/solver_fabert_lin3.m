function locations = solver_fabert_lin3(distances,anchorloc)

%% Create some help variables
[N,~] = size(anchorloc);
sumSquaredDistances = distancesSumSquared(distances);
sumSquaredXp = anchorCoordinatesSumSquared(1,anchorloc);
sumSquaredYp = anchorCoordinatesSumSquared(2,anchorloc);
sumXp = anchorCoordinatesSum(1,anchorloc);
sumYp = anchorCoordinatesSum(2,anchorloc);


%% Calculate location
B = createVectorB();
A = createMatrixA();
W = createWeightsMatrix();
% locations = A\B';
locations = (W'*A)\(B'.*createWeightsVector()');


%% ============================== Nested functions ==============================

    function w = createWeightsMatrix()
        tmp = createWeightsVector();
        w = eye(N,N).*tmp(ones(N,1),:);
    end

    function w = createWeightsVector()
        w = 1./(distances.^6);
    end

    function a = createMatrixA()
        for n = 1:N
            a(n,1:3) = [(((2*sumXp)/N) - (2 * anchorloc(n,1))) ...
                (((2*sumYp)/N) - (2 * anchorloc(n,2))) 1/N];
        end
    end

    function b = createVectorB()
        for n = 1:N
            b(n) = distances(n)^2 + ...
                (sumSquaredXp + sumSquaredYp - sumSquaredDistances)/N ...
                -(anchorloc(n,1)^2 + anchorloc(n,2)^2);
        end
    end

    function result = distancesSumSquared(distances)
        result = sum(distances.^2);
    end

    function result = anchorCoordinatesSumSquared(dim,anchorloc)
        result = sum(anchorloc(:,dim).^2);
    end

    function result = anchorCoordinatesSum(dim,anchorloc)
        result = sum(anchorloc(:,dim));
    end

end %main function