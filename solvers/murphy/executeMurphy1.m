function [result] = executeMurphy1(data)
try
    for i = 1:length(data.distances())
        tmp = data.anchorpos(i,:);
        [r,c] = size(tmp);
        if r==1 || c==1
            tmp = reshape(tmp,2,3)';
        end
        result(i,1:2) = solver_murphy_1(data.distances(i,:),reshaped);
    end
catch
    for i = 1:length(data.Distances())
        result(i,1:2) = solver_murphy_1(data.Distances(i,:),data.AnchorPositions)';
    end
end
end