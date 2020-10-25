function [result] = executeMurphy1(data)
for i = 1:length(data.Distances())
    result(i,1:2) = solver_murphy_1(data.Distances(i,:),data.AnchorPositions)';
end