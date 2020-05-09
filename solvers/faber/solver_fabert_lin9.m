function locations = solver_fabert_lin9(distances,anchorloc)

%% Create some help variables
[N,~] = size(anchorloc);

sumSquaredXp = anchorCoordinatesSumSquared(1,anchorloc);
sumSquaredYp = anchorCoordinatesSumSquared(2,anchorloc);
sumXp = anchorCoordinatesSum(1,anchorloc);
sumYp = anchorCoordinatesSum(2,anchorloc);
sumDistances = sum(distances(:));
anchorloc = anchorloc - [sumXp/N sumYp/N];


%% Calculate location
b = createVectorB();
A = createMatrixA();
locations = (A\b) + [sumXp/N sumYp/N 0]';



%% ============================== Nested functions ==============================
    function a = createMatrixA()
        for n = 1:N
            a(n,1:3) = [-2*anchorloc(n,1) -2*anchorloc(n,2)  1/N] * (1/z(n));
        end
    end

    function b = createVectorB()
        b = ones(N,1);
    end

    function z = z(i)
        z = distances(i)^2  ...
            + ((sumSquaredXp + sumSquaredYp)/N)  ...
            - (anchorloc(i,1)^2 + anchorloc(i,2)^2);
    end

    function result = anchorCoordinatesSumSquared(dim,anchorloc)
        result = sum(anchorloc(:,dim).^2);
    end

    function result = anchorCoordinatesSum(dim,anchorloc)
        result = sum(anchorloc(:,dim));
    end

    function result = distancesSumSquared(distances)
        result = sum(distances.^2);
    end
end %main function